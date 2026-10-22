require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_3 = {}


function guild_guildmasters_room_ch_3.Tropius_Action(chara, activator)
	--He gives you a few wands as a one-off to help you with your mission
	if not SV.Chapter3.DefeatedBoss then
		if not SV.Chapter3.TropiusGaveWand then
			GeneralFunctions.StartConversation(chara, "Salut, équipe[pause=10]" .. GAME:GetTeamName() .. "![pause=0]Félicitations pour votre première mission réussie !", "Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_001'], CharacterEssentials.GetCharacterName("Camerupt"), CharacterEssentials.GetCharacterName("Numel")))
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_002']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_003']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_004']))
			GAME:WaitFrames(20)
			GeneralFunctions.RewardItem("wand_totter", false, 4)
			GAME:WaitFrames(20)
			UI:SetSpeaker(chara)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_005']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_006']))

			GAME:WaitFrames(20)
			UI:SetSpeaker(CH('Teammate1'))
			GeneralFunctions.SetEmotion("Inspired")
			GROUND:CharSetEmote(CH('Teammate1'), "happy", 0)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_007']))

			GAME:WaitFrames(20)
			GROUND:CharSetEmote(CH('Teammate1'), "", 0)
			UI:SetSpeaker(chara)
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_008']))
			SV.Chapter3.TropiusGaveWand = true
		elseif not SV.Chapter3.EnteredCavern then
			GeneralFunctions.StartConversation(chara, "Bonne chance pour capturer ce hors-la-loi ![pause=0]Je sais que vous pouvez le faire tous les deux !", "Happy")
		else--failed the dungeon at least once
			GeneralFunctions.StartConversation(chara, "Vous avez du mal à capturer ce hors-la-loi ?[pause=0]Ils peuvent être des adversaires assez coriaces !")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_009']))
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_010']))
		end
	else
		GeneralFunctions.StartConversation(chara, "Salut, l'équipe[pause=10]" .. GAME:GetTeamName() .. "![pause=0]Excellent travail de capture de votre premier hors-la-loi !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR3_011']))
	end
	GeneralFunctions.EndConversation(chara)
end


return guild_guildmasters_room_ch_3
