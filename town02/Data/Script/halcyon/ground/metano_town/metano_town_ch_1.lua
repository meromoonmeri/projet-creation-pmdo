require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_1 = {}


--partner passes by guild with a sad expression
--Team Style sees him and talk about how they're so great and gonna join the guild
--partner walks away wistfully
function metano_town_ch_1.PartnerLongingCutscene()
	--Cutscene where partner looks longingly at the guild, then walks away
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(648, 1216, 1, false)
	GROUND:TeleportTo(partner, 840, 1232, Direction.Left)
	--GROUND:Unhide("Growlithe")
	GROUND:Hide("Green_Merchant")
	GROUND:Hide("Red_Merchant")

	--[[local luxio, glameow, cacnea =
		CharacterEssentials.MakeCharactersFromList({
			{'Luxio', 440, 1208, Direction.Right},
			{'Glameow', 416, 1192, Direction.Right},
			{'Cacnea', 416, 1224, Direction.Right}
		})
	]]--
	GAME:FadeIn(40)



	--walk from offscreen to under the bridge
	GROUND:MoveToPosition(partner, 704, 1232, false, 1)
	GROUND:MoveToPosition(partner, 680, 1208, false, 1)
	GROUND:MoveToPosition(partner, 640, 1208, false, 1)
	GAME:WaitFrames(20)
	--they turn towards the guild and pause
	GROUND:CharAnimateTurn(partner, Direction.Up, 4, false)
	GAME:WaitFrames(60)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_001']))
	GAME:WaitFrames(60)

--[[
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_002']))
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)


	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({partner, luxio}, 648, 1208, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(60)

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(luxio, Direction.Right, 160, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:MoveInDirection(glameow, Direction.Right, 160, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												  GROUND:MoveInDirection(cacnea, Direction.Right, 160, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(628, 1216, 80, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, true, true, Direction.Left)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_003']))
	GAME:WaitFrames(20)


--tone should be condescending and smug, but not necessarily mean
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_004']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_005']))
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(12)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_006']))
	GROUND:CharTurnToCharAnimated(partner, luxio, 4)
	GAME:WaitFrames(12)

	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_007']))
	GROUND:CharAnimateTurnTo(luxio, Direction.Left, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_008']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_009']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_010']))
		--they walk a bit closer

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_011']))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(glameow, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharTurnToCharAnimated(cacnea, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_012']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(

	]]--




	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)


	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 444, 1208, false, 1) end)
	GAME:WaitFrames(186)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1})


	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")

end

--enter guild cutscene, partner runs in leaving you in the dust
function metano_town_ch_1.RunSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1200, false, 3)
	GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 4)
end

--walking up to growlithe.
function metano_town_ch_1.WalkSequenceHero()
	GROUND:MoveToPosition(CH('PLAYER'), 648, 1032, false, 1)
	GeneralFunctions.EightWayMove(CH('PLAYER'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('PLAYER'), 696, 948, false, 1)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), CH('Growlithe'), 4)
end

--walking up to growlithe
function metano_town_ch_1.WalkSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1032, false, 1)
	GeneralFunctions.EightWayMove(CH('Teammate1'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('Teammate1'), 696, 924, false, 1)
	GROUND:CharTurnToCharAnimated(CH('Teammate1'), CH('Growlithe'), 4)
end

--growlithe turning as you walk towards him, with him getting excited
function metano_town_ch_1.GrowlitheSequence()
	GAME:WaitFrames(20)
	local chara = CH('Growlithe')
	GROUND:CharSetEmote(chara, "notice", 1)
	GROUND:CharSetAnim(chara, 'Idle', true)
	GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(chara, Direction.DownRight, 4)
end

--growlithe leaving his post to go inside the guild
function metano_town_ch_1.GrowlitheRunInside()
	local chara = CH('Growlithe')
	SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
	GROUND:AnimateToPosition(chara, 'Rumble', Direction.Right, 694, 924, 1, 2, 0)
	GROUND:MoveToPosition(chara, 712, 924, true, 4)
	GROUND:MoveToPosition(chara, 712, 876, true, 4)
	GROUND:Hide('Growlithe')
end

function metano_town_ch_1.PartnerPushedBack()
	GAME:WaitFrames(4)
	local chara = CH('Teammate1')
	GROUND:CharSetEmote(chara, "shock", 1)
	GROUND:AnimateToPosition(chara, 'Hurt', Direction.Down, 696, 900, 1, 3, 0)
	GROUND:CharEndAnim(chara)
	GAME:WaitFrames(6)
	--GROUND:EntTurn(chara, Direction.Down)
	--GAME:WaitFrames(12)
	--GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
	--GAME:WaitFrames(12)
	--GROUND:CharAnimateTurnTo(chara, Direction.UpRight, 4)
	GeneralFunctions.FaceMovingCharacter(chara, CH('Growlithe'))
end

function metano_town_ch_1.HeroPushedBack()
	GAME:WaitFrames(6)
	local chara = CH('PLAYER')
	GROUND:CharSetEmote(chara, "shock", 1)
	GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
end
--hero and partner enter the guild
function metano_town_ch_1.EnterGuild()
	--center of guild: 744, 796

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Growlithe')
	GROUND:AddMapStatus("dusk")--dusk
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:Hide("Green_Merchant")--hide merchants
	GROUND:Hide("Red_Merchant")
	GROUND:Hide("Guild_Entrance")--disable map transition object
	UI:ResetSpeaker()
	GAME:MoveCamera(640, 1208, 1, false)
	GROUND:TeleportTo(partner, 444, 1200, Direction.Right)
	GROUND:TeleportTo(hero, 380, 1200, Direction.Right)
	GAME:FadeIn(40)

	--the partner runs in due to excitement, hero struggling to keep up
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 616, 1200, false, 2) end)
	local coro2 = TASK:BranchCoroutine(metano_town_ch_1.RunSequencePartner)
	TASK:JoinCoroutines({coro1, coro2})

	GeneralFunctions.EmoteAndPause(hero, "Sweating", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowTimedDialogue("*huff*[pause=20] *huff*", 60)

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetAnim(partner, 'Idle', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_013'], hero:GetDisplayName()))
	GROUND:CharSetAnim(partner, 'None', true)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(10)

	GeneralFunctions.LookAround(partner, 2, 4, false, false, false)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_014']))
	GAME:WaitFrames(20)

	--turn towards  the guild
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_015']))
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_016']))
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_020']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je comprends pourquoi " .. partner:GetDisplayName() .. " aurait peur de venir ici,[pause=10]même maintenant...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais ils ont refusé " .. GeneralFunctions.GetPronoun(partner, "them") .. " uniquement parce que " .. GeneralFunctions.GetPronoun(partner, "they") .. " n'avait pas de partenaire.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Maintenant que je suis là,[pause=10] il ne devrait y avoir aucun problème,[pause=10] n'est-ce pas ?)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_021']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_022']))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(partner, "DeepBreath")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_023']))
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)

	--show the guild
	local frameDur = GeneralFunctions.CalculateCameraFrames(744, 796, 684, 928, 2)
	GAME:MoveCamera(744, 796, 1, false)
	GAME:WaitFrames(40)
	GAME:FadeIn(40)
	GAME:WaitFrames(120)
	GROUND:TeleportTo(partner, 648, 1064, Direction.Up)
	GROUND:TeleportTo(hero, 648, 1096, Direction.Up)

	coro1= TASK:BranchCoroutine(function() GAME:MoveCamera(684, 928, frameDur, false) end)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({hero, partner, growlithe}, 744, 796, 1) end)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.WalkSequenceHero)
	local coro3 = TASK:BranchCoroutine(metano_town_ch_1.WalkSequencePartner)
	local coro4 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheSequence)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
	--696, 912

	--growlithe is excited to see you
	--dont give their name in the textbox at first
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, growlithe.CurrentForm.Species, growlithe.CurrentForm.Form, growlithe.CurrentForm.Skin, growlithe.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(growlithe, "glowing", 0)
	GeneralFunctions.Hop(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_024'], partner:GetDisplayName()))
	GROUND:EntTurn(growlithe, Direction.DownRight)
	GROUND:CharSetEmote(growlithe, "", 0)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	GROUND:CharSetAnim(growlithe, 'None', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_025']))
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_026']))
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)

	--introduce hero to growlithe, partner and growlithe are already acquainted
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_027'], growlithe:GetDisplayName()))
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:EntTurn(hero, Direction.Up)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_028'], hero:GetDisplayName()))
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GROUND:EntTurn(hero, Direction.UpLeft)
	--[[Dialogue removed for being a bit unnecessary
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_029'], GeneralFunctions.GetPronoun(hero, "they're", true)))
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_030'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")]]--
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_031'], GeneralFunctions.GetPronoun(hero, "they're", true)))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(growlithe, "glowing", 0)
	GROUND:EntTurn(growlithe, Direction.DownRight)
	GROUND:CharSetAnim(growlithe, 'Idle', true)
--	GeneralFunctions.Hop(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_032'], hero:GetDisplayName(), growlithe:GetDisplayName()))
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(20)
	GROUND:EntTurn(growlithe, Direction.Right)

	--whatcha doin here?
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_033']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_034']))
	GROUND:CharAnimateTurnTo(partner,Direction.Down,4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_035']))
	GAME:WaitFrames(20)

	--woah im glad! more friends :) I'll go let them know you're coming
	GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
	GAME:WaitFrames(10)
	GeneralFunctions.DoubleHop(growlithe, nil, 8, 8, true, true)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_037']))
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_038']))


	--he hops over his little post, pushing you to the side, and runs inside the guild.
	--partner and hero reflect on how well it's going, growlithe comes back out after a while
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheRunInside)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.PartnerPushedBack)
	coro3 = TASK:BranchCoroutine(metano_town_ch_1.HeroPushedBack)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(60)
	GROUND:CharSetEmote(partner, "sweatdrop", 1)
	GAME:WaitFrames(6)
	GROUND:CharSetEmote(hero, "sweatdrop", 1)
	SOUND:PlayBattleSE('EVT_Emote_Sweatdrop')
	GAME:WaitFrames(54)

	--hyko is easily excitable
	GeneralFunctions.HeroDialogue(hero, '(...)', 'Stunned')
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_039'], growlithe:GetDisplayName()))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_040']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_041']))
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(C'est rassurant de savoir qu'on vient juste d'arriver et qu'on nous prend déjà si gentiment...)", "Normal")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	GeneralFunctions.HeroDialogue(hero, "(...Mais est-ce vraiment la guilde ?[pause=0]C'est un arbre ?[pause=0]Je m'attendais à quelque chose de différent...)", "Worried")
	GAME:WaitFrames(60)

	--hyko returns
	GROUND:Unhide('Growlithe')
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheReturn)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) metano_town_ch_1.TeamWatchGrowlithe(hero) end)
	coro3 = TASK:BranchCoroutine(function() metano_town_ch_1.TeamWatchGrowlithe(partner) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--he tells you to meet up with phileas on the 2nd floor
	GAME:WaitFrames(10)
	GROUND:MoveToPosition(partner, 696, 924, false, 1)
	GROUND:CharTurnToCharAnimated(partner, growlithe, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.DoubleHop(growlithe, nil, 8, 8, true, true)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_042']))
	GROUND:CharSetAnim(growlithe, 'None', true)
	GROUND:CharSetEmote(growlithe, "", 0)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_043'], CharacterEssentials.GetCharacterName("Noctowl")))


	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT1_044'], growlithe:GetDisplayName(), CharacterEssentials.GetCharacterName("Noctowl")))
	UI:SetSpeaker(growlithe)

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.TeamEnterGuildHero)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.TeamEnterGuildPartner)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Bonne chance, fraise[pause=10]![pause=20]Je sais que vous pouvez le faire !", 60) end)
	coro4 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	GAME:EnterGroundMap("guild_first_floor", "Main_Entrance_Marker")



end



function metano_town_ch_1.TeamEnterGuildPartner()
	local chara = CH('Teammate1')
	GeneralFunctions.EightWayMove(chara, 712, 908, false, 1)
	GeneralFunctions.EightWayMove(chara, 712, 876, false, 1)
	GROUND:Hide(chara.EntName)
end


function metano_town_ch_1.TeamEnterGuildHero()
	local chara = CH('PLAYER')
	GAME:WaitFrames(10)
	GeneralFunctions.EightWayMove(chara, 712, 908, false, 1)
	GeneralFunctions.EightWayMove(chara, 712, 876, false, 1)
	GROUND:Hide(chara.EntName)
end

--comes back from inside the guild to tell you to go on in
function metano_town_ch_1.GrowlitheReturn()
	local chara = CH('Growlithe')
	GROUND:MoveToPosition(chara, 712, 924, false, 2)
	GROUND:MoveToPosition(chara, 694, 924, false, 2)
	SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
	GROUND:AnimateToPosition(chara, 'Rumble', Direction.Left, 662, 924, 1, 2, 0)
	GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
end

function metano_town_ch_1.TeamWatchGrowlithe(chara)
	GAME:WaitFrames(10)
	GROUND:CharTurnToChar(chara, CH('Growlithe'))
	GROUND:CharSetEmote(chara, "exclaim", 1)
	GeneralFunctions.FaceMovingCharacter(chara, CH('Growlithe'))
end
