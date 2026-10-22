require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

guild_bottom_right_bedroom_ch_3 = {}

function guild_bottom_right_bedroom_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 88, 256, Direction.Down}
		})
	end
	GAME:FadeIn(20)
end

function guild_bottom_right_bedroom_ch_3.Zigzagoon_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	-- Cadrage soigné sur Almotz et son bureau
	GAME:MoveCamera(104, 240, 20, false)
	GROUND:CharTurnToCharAnimated(chara, activator, 4)
	pcall(function() GROUND:CharSetEmote(chara, 'notice', 1) end)
	GAME:WaitFrames(15)
	
	GeneralFunctions.StartConversation(chara, "Hé, l'équipe [team] ![pause=15] Quoi de neuf ?", 'Happy')
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR3_001']))
	
	pcall(function() GROUND:CharSetEmote(chara, 'inspired', 1) end)
	GeneralFunctions.SetEmotion('Inspired')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR3_002']))
	
	-- Réaction du partenaire qui regarde les piles de parchemins
	if partner then
		GROUND:CharTurnToCharAnimated(partner, chara, 4)
		pcall(function() GROUND:CharSetEmote(partner, 'happy', 1) end)
	end
	
	GeneralFunctions.SetEmotion('Happy')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR3_003']))
	
	-- Micro-détail : Almotz retourne doucement à ses notes avec détermination
	GAME:WaitFrames(10)
	pcall(function() GROUND:CharSetEmote(chara, 'glowing', 1) end)
	GeneralFunctions.SetEmotion('Determined')
	UI:WaitShowDialogue("J'ai presque fini de cartographier les sentiers des voleurs.[pause=20] Faites attention à vous dans les cavernes !")
	
	GeneralFunctions.EndConversation(chara)
	GAME:MoveCamera(0, 0, 20, true)
end

return guild_bottom_right_bedroom_ch_3
