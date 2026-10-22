require 'origin.common'
require 'halcyon.HeroVisions'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_3 = {}



--show title card, then do a generic wakeup.
function guild_heros_room_ch_3.FirstMorning()
	GAME:FadeOut(false, 1)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(CH('Teammate1'))
	UI:ResetSpeaker()
	SOUND:StopBGM()
	SV.Chapter3.ShowedTitleCard = true
	GAME:WaitFrames(60)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapitre 3\n\nRivaux\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_3", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(120)

	-- PREMIERE VISION. Le heros se reveille avec l'image d'un autre monde
	-- deja dans les yeux. Personne d'autre ne l'a vue.
	HeroVisions.TryTrigger('chasse', CH('Teammate1'))
	GAME:WaitFrames(20)

	guild_heros_room_helper.Morning(true)

end

--The scene before previewing the root
function guild_heros_room_ch_3.PostOutlawBedtalkFirstHalf()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GAME:FadeIn(40)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	SOUND:PlayBGM('Goodnight.ogg', true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_003']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_004'], CharacterEssentials.GetCharacterName("Sandile")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_005']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_010']))
	
	GAME:WaitFrames(20)
	--GeneralFunctions.StartTremble(partner)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_011'], CharacterEssentials.GetCharacterName("Bisharp")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_012'], CharacterEssentials.GetCharacterName("Bisharp"), CharacterEssentials.GetCharacterName("Sandile")))
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "...)", "Sad")

	GAME:WaitFrames(20)
	--GeneralFunctions.StopTremble(partner)
	GeneralFunctions.ShakeHead(partner)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_013']))
	
	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(120)
	GROUND:CharSetAnim(partner, "Laying", true)
	GROUND:CharSetAnim(hero, "Laying", true)
	GAME:FadeIn(60)

	GAME:WaitFrames(60)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_014']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_015'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_016']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_017']))
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_018'], CharacterEssentials.GetCharacterName("Relicanth")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_020'], zone:GetColoredName()))
	--Had to remove this line for consistency with the partner dialogue at the pond... partner says there if he HASNT been caught lately, he gets a story. This dialogue here originally said the opposite
	--UI:WaitShowDialogue("...After yelling at me for trying to sneak into the forest,[pause=10] that is...")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_021']))
	
	GAME:WaitFrames(20)
	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_022']))
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:PlayBGM('Anima Core.ogg', false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_023']))
	--cut here to a preview of the root
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	GAME:EnterGroundMap('first_core_location', 'Main_Entrance_Marker', true)
end 


--After previewing root
function guild_heros_room_ch_3.PostOutlawBedtalkSecondHalf()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false, true)
	--SOUND:PlayBGM('Time Gear Remix.ogg', false)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetAnim(partner, "Laying", true)
	GROUND:CharSetAnim(hero, "Laying", true)
	GAME:FadeIn(40)

	
	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_024'], CharacterEssentials.GetCharacterName("Relicanth")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_026']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_028']))
	
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(60)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_031']))


	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_032'], hero:GetDisplayName()))
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(120)
		
	GAME:EnterGroundMap('first_core_location', 'Main_Entrance_Marker')


end 

function guild_heros_room_ch_3.DemoThanks()
	UI:ResetSpeaker()
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_033']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_034']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_035']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_039']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_041']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_042']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_043']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_044']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_046']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_047']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR3_048']))
end