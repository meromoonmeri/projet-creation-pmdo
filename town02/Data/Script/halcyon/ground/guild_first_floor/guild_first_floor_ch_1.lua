require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_first_floor_ch_1 = {}

function guild_first_floor_ch_1.EnterGuild()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	--swap the partner and hero's spawn points, as the partner is leading in this instance
	local leftPos = hero.Position
	local rightPos = partner.Position
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(160, 160, 1, false)
	GROUND:TeleportTo(partner, leftPos.X, leftPos.Y, Direction.Up)
	GROUND:TeleportTo(hero, rightPos.X, rightPos.Y, Direction.Up)
	GAME:FadeIn(40)

	--wow we're inside a tree!
	GAME:WaitFrames(20)
	GeneralFunctions.Recoil(hero)
	GROUND:CharSetEmote(hero, "shock", 1)
	GeneralFunctions.HeroDialogue(hero, "(Wow ![pause=0]La guilde est entièrement dans un arbre !?)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	--UI:WaitShowDialogue("My jaw dropped the first time I came inside the guild too!")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_001']))
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_002']))

	--how old does that make the partner then?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Quel âge cela donne-t-il alors à " .. partner:GetDisplayName() .. " ?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(...Quel âge ai-je sous cette forme d'ailleurs ?)", "Worried")
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_003']))
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_004'], CharacterEssentials.GetCharacterName("Noctowl")))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_005']))

	--walk towards the stairs but remember to tell hero not to blab about being human
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 88, 152, false, 1)
												  GROUND:MoveToPosition(partner, 88, 112, false, 1)
												  GROUND:CharSetEmote(partner, "exclaim", 1)
												  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2") end)
	GeneralFunctions.WaitThenMove(hero, 136, 200, false, 1, 10)
	GROUND:MoveToPosition(hero, 120, 184, false, 1)
	GeneralFunctions.EightWayMove(hero, 88, 144, false, 1)
	TASK:JoinCoroutines({coro1})

	GeneralFunctions.SetEmotion("Surprised")
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(hero, "exclaim", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_006']))

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)

	--dont tell anyone
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_007']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_013']))

	-- :(
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_014']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_015']))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G1F1_016'], CharacterEssentials.GetCharacterName("Noctowl")))
	GAME:WaitFrames(20)

	--walk away, then walk away again while fading out
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 88, 104, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 88, 136, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 128, 64, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:FadeOut(false, 40) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 88, 104, false, 1)
												  GROUND:MoveToPosition(hero, 92, 100, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")


end
