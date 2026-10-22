require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

first_core_location_ch_3 = {}

function first_core_location_ch_3.RootPreviewScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	--SOUND:PlayBGM('Time Gear Remix.ogg', false)
	GAME:CutsceneMode(true)
	GROUND:Hide(partner.EntName)
	GROUND:Hide(hero.EntName)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GAME:MoveCamera(276, 134, 1, false)
	GAME:FadeIn(40)
	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_001'], CharacterEssentials.GetCharacterName("Relicanth")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_003']))
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_005'], CharacterEssentials.GetCharacterName("Relicanth")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_007'], CharacterEssentials.GetCharacterName("Relicanth")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_009']))
	
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	SV.Chapter3.RootSceneTransition = true--mark this flag so the game knows to resume the cutscene in the proper place back in the hero room
	GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker', true)

end

function first_core_location_ch_3.RootDeactivationScene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:Hide(partner.EntName)
	GROUND:Hide(hero.EntName)
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	GAME:MoveCamera(276, 134, 1, false)
	local root = OBJ('Anima_Root')
	local core = OBJ('Anima_Core')
	SOUND:FadeInSE('Anima Core Glow', 60)
	GAME:FadeIn(60)

	--setup darkness
	--It'll fade in for 200 frames, last 0 frames, and fade out in 0 frames. It'll transition to the darkness map status though at 200 frames.
	local overlay = RogueEssence.Content.FiniteOverlayEmitter()
    overlay.TotalTime = 0;
	overlay.FadeIn = 200;
	overlay.FadeOut = 0;
	overlay.Layer = DrawLayer.Top;
	overlay.Anim = RogueEssence.Content.BGAnimData("White", 0)
	overlay.Color = Color(0, 0, 0, 76/255)
	
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root', 10, 0, 15, Direction.Down)
	GROUND:ObjectSetDefaultAnim(core, 'Anima_Core', 10, 0, 31, Direction.Down)

	GROUND:ObjectWaitAnimFrame(core, 0)
	GROUND:ObjectWaitAnimFrame(core, 25)
	SOUND:FadeOutSE('Anima Core Glow', 60)
	GROUND:ObjectWaitAnimFrame(core, 0)
	
	SOUND:PlayBattleSE('EVT_EP_Nightmare_Break')
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(core, 10, 0, 11, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 11, 11, Direction.Down)
	
	GROUND:ObjectWaitAnimFrame(core, 11)
	GAME:WaitFrames(40)
	
	--move core slowly down after deactivating
	for i = 1, 10, 1 do
		GROUND:MoveObjectToPosition(core, core.Position.X, core.Position.Y + 1, 1)
		GAME:WaitFrames(8)
	end
	
	GROUND:ObjectWaitAnimFrame(root, 0)
	
	GROUND:PlayVFX(overlay, core.Position.X, core.Position.Y)
	SOUND:PlayBattleSE("_UNK_EVT_079")
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(root, 40, 0, 5, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 5, 5, Direction.Down)
	
	GAME:WaitFrames(200)
	GROUND:AddMapStatus("darkness")
	GAME:WaitFrames(180)
	GAME:FadeOut(false, 120)
	
	GAME:WaitFrames(60)
	UI:ResetSpeaker()
	
	--[[
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_014']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_016']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_022']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FCL3_024']))
	GAME:WaitFrames(60)
	
	SV.Chapter3 = 
	{
		ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
		FinishedOutlawIntro = false,--did shuca and ganlon teach you about outlaws?
		MetTeamStyle = false,--did you meet team style?
		FinishedCafeCutscene = false,--did partner point out the cafe's open?
		EnteredCavern = false,--did duo enter the dungeon?
		FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
		EncounteredBoss = false,--did duo find team style in the dungeon yet?
		LostToBoss = false,--did duo die to boss?
		EscapedBoss = false,--due team use an escape orb to escape boss?
		DefeatedBoss = false, --did duo defeat team style?
		FinishedRootScene = false, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not

		TropiusGaveWand = false,--did tropius give some wands to help the duo?
		BreloomGirafarigConvo = false --talked to breloom/girafarig about their expedition?
	}
	]]--
	
	SV.Chapter3.FinishedRootScene = true
	SV.ChapterProgression.CurrentStoryDungeon = ''--Clear the current story dungeon flag
	SV.TemporaryFlags.MorningAddress = true
	SV.TemporaryFlags.MorningWakeup = true
	GeneralFunctions.EndOfDay()
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end
	



return first_core_location_ch_3




