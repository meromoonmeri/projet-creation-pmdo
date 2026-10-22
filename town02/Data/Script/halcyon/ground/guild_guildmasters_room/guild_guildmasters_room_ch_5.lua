require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_5 = {}

function guild_guildmasters_room_ch_5.SetupGround()

	local tropius = CH('Tropius')
	GROUND:TeleportTo(tropius, 280, 168, Direction.DownRight)


	local noctowl, girafarig, breloom = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 296, 224, Direction.UpRight},
			{"Girafarig", 280, 208, Direction.Right},
			{"Breloom", 296, 200, Direction.Right}
		})
		
		
	GAME:FadeIn(20)
	
end


function guild_guildmasters_room_ch_5.Tropius_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GeneralFunctions.StartConversation(chara, "...Nous devrons rester en groupe aussi longtemps que possible.[pause=0] Même si nous devrons peut-être nous séparer par nécessité...", "Normal", false)
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(chara, hero, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_001'], GAME:GetTeamName()))
	UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['GMR5_002']), true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)
	if result then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_003']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_004'], _DATA:GetMonster('audino'):GetColoredName()))
		UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['GMR5_005']), true)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:WaitFrames(20)
		if result then
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_006']))
			GAME:WaitFrames(20)
			
			UI:SetSpeaker(chara)		
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_007']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_008'], CharacterEssentials.GetCharacterName("Noctowl")))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_009']))
			GAME:WaitFrames(20)
			
			--Set flags needed for the expedition, and send home characters in slots 3/4.
			GAME:SetCanRecruit(false)--disable recruiting for duration of expedition
			SV.Chapter5.ReadyForExpedition = true
			GeneralFunctions.DefaultParty(false)
			
			SOUND:FadeOutBGM(60)
			GAME:FadeOut(false, 60)
			GAME:WaitFrames(60)
			GeneralFunctions.EndConversation(chara)
			GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
			
		else
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Sad")
			GROUND:CharSetEmote(partner, "sweating", 1)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_010']))
			GAME:WaitFrames(20)
			
			UI:SetSpeaker(chara)
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_011']))
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_012']))
		end		
	else 
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Sad")
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_013']))
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(chara)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_014']))
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_015']))
	end
	GROUND:CharAnimateTurnTo(chara, Direction.DownRight, 4)
	GeneralFunctions.EndConversation(chara)
end

function guild_guildmasters_room_ch_5.Noctowl_Action(chara, activator)
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
--	GeneralFunctions.StartConversation(chara, "According to your map,[pause=10] " .. ruins:GetColoredName() .. " lies just beyond " .. mountain:GetColoredName() .. ".", "Normal", false)
--	UI:WaitShowDialogue("As such,[pause=10] we will need to travel through the mountain no matter what route we take.")
	--GeneralFunctions.StartConversation(chara, "...If we take this more roundabout route,[pause=10] the raw distance traveled would be greater.", "Normal", false)
	--UI:WaitShowDialogue("However,[pause=10] such a course would allow us to navigate around some of the mystery dungeons you two encountered while scouting.")
	--UI:WaitShowDialogue("That should make it the most efficient path to " .. ruins:GetColoredName() .. ".")
	GeneralFunctions.StartConversation(chara, "...Ton itinéraire est très prometteur.[pause=0] Il nous permettra d'atteindre les ruines dans environ une semaine.", "Normal", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_016']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_017']))
	
	GeneralFunctions.EndConversation(chara)
end

function guild_guildmasters_room_ch_5.Breloom_Action(chara, activator)
	--local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	--local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	--GeneralFunctions.StartConversation(chara, "..." .. ruins:GetColoredName() .. " lies just past " .. mountain:GetColoredName() .. ",[pause=10] so there's no avoiding that mystery dungeon.", "Normal", false)
	--GeneralFunctions.SetEmotion("Worried")
	--UI:WaitShowDialogue("It's unfortunate,[pause=10] given how harsh that place is![pause=0] Even for me and " .. CharacterEssentials.GetCharacterName("Girafarig") .. ",[pause=10] getting through was a struggle!")
	--GeneralFunctions.StartConversation(chara, "...That's why me and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " decided to call the ruins that.", "Normal", false)
	--GeneralFunctions.SetEmotion("Happy")
	--UI:WaitShowDialogue("Pretty clever,[pause=10] huh?")
	GeneralFunctions.StartConversation(chara, "...Ce donjon mystère en particulier était éprouvant.[pause=0] Même pour moi et " .. CharacterEssentials.GetCharacterName("Girafarig") .. ",[pause=10] le traverser fut difficile !", "Worried", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_018']))
	GeneralFunctions.EndConversation(chara)
end

--something about mystery dungeons being required
function guild_guildmasters_room_ch_5.Girafarig_Action(chara, activator)
	--GeneralFunctions.StartConversation(chara, "...Woah " .. CharacterEssentials.GetCharacterName("Noctowl") .. ",[pause=10] your map skills are even better than " .. CharacterEssentials.GetCharacterName("Tail") .. "'s!", "Normal", false)
	GeneralFunctions.StartConversation(chara, "...Nous avons fouillé les ruines de fond en comble,[pause=10] mais nous n'y avons rien compris ![pause=0] C'est un mystère total !", "Worried", false)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR5_019']))
	GeneralFunctions.EndConversation(chara)
end

return guild_guildmasters_room_ch_5


--[[
>have to go through mystery dungeons
>this route is efficient
>we're so clever!
>phileas suggests some improvements?
>Kino and Reinier are demonstrated to be pretty competent despite their demeanor
>hints about what their strategy is going to be (stay together -> split into teams)

]]--
