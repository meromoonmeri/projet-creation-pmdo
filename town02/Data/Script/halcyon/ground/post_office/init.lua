require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'

local post_office = {}

--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function post_office.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_post_office")

  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
    SOUND:PlayBGM(SV.metano_town.Song, true)
  end

--Remove nicknames from characters if the nickname mod is enabled.
  if CONFIG.UseNicknames() then
	CH('Connect_Owner').Data.Nickname = CharacterEssentials.GetCharacterName('Pelipper_Connect')
	CH('Rescue_Owner').Data.Nickname = CharacterEssentials.GetCharacterName('Pelipper_Rescue')
  else
	CH('Connect_Owner').Data.Nickname = 'Pelipper'
	CH('Rescue_Owner').Data.Nickname = 'Pelipper'
  end


end

function post_office.Enter(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  post_office.PlotScripting()
end

function post_office.Update(map, time)
end

function post_office.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	post_office.PlotScripting()
end

function post_office.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function post_office.PlotScripting()

	local rescue = SV.General.Rescue
	if rescue ~= nil then
		local hero = CH('PLAYER')
		local partner = CH('Teammate1')
		-- GROUND:TeleportTo(hero, MRKR('Rescue_Spawn').Position.X, MRKR('Rescue_Spawn').Position.Y, MRKR('Rescue_Spawn').Direction)
		-- GROUND:TeleportTo(partner, MRKR('Rescue_Spawn_Partner').Position.X, MRKR('Rescue_Spawn_Partner').Position.Y, MRKR('Rescue_Spawn_Partner').Direction)
		post_office.RescueMessage()

	else
		GAME:FadeIn(20)
	end

end

function post_office.RescueMessage()
  local rescue = SV.General.Rescue

  if rescue ~= nil then
    local chara = CH('Rescue_Owner')
	UI:SetSpeaker(chara)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	--print(MRKR('Rescue_Spawn'))
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, MRKR('Rescue_Spawn').Position.X, MRKR('Rescue_Spawn').Position.Y, MRKR('Rescue_Spawn').Direction)
	GROUND:TeleportTo(partner, MRKR('Rescue_Spawn_Partner').Position.X, MRKR('Rescue_Spawn_Partner').Position.Y, MRKR('Rescue_Spawn_Partner').Direction)
	GAME:MoveCamera(232, 188, 1, false)
	local result = SV.General.Rescue
	SV.General.Rescue = nil
	GAME:FadeIn(40)
	if result == RogueEssence.Data.GameProgress.ResultType.Rescue then
		GAME:WaitFrames(20)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Success_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Success_003']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Success_004']))
	elseif result == RogueEssence.Data.GameProgress.ResultType.Cleared or result == RogueEssence.Data.GameProgress.ResultType.Escaped then
		GAME:WaitFrames(20)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Miss_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Miss_002']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Miss_003']))
	else
		GAME:WaitFrames(10)
		GeneralFunctions.EmoteAndPause(chara, "Sweating", true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Fail_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Return_Fail_002']))
	end
    GAME:WaitFrames(10)
	GeneralFunctions.PanCamera()
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
  end
end
--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------

--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------
function post_office.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Post_Office_Entrance_Marker", true)
  SV.partner.Spawn = 'Post_Office_Entrance_Marker_Partner'
end


--PARLER AUX PREPOSES DIRECTEMENT. Les deux sont poses avec
--triggerType = 1 et 4 cases libres sur 4 : le joueur peut les aborder,
--mais aucun handler n'existait et ils restaient muets.
--L'appariement vient des positions relevees sur post_office.rsground :
--Connect_Owner (168,158) est derriere Main_Desk (160,176), et
--Rescue_Owner (224,158) derriere Side_Desk (216,176).
function post_office.Connect_Owner_Action(chara, activator)
  post_office.Main_Desk_Action(chara, activator)
end

function post_office.Rescue_Owner_Action(chara, activator)
  post_office.Side_Desk_Action(chara, activator)
end

function post_office.Main_Desk_Action(obj, activator)

	local chara = CH('Connect_Owner')
	local state = 0
    local repeated = false
    UI:SetSpeaker(chara)

  	--Only allow players the ability to go on rescues when they're bronze rank (They've started chapter 4)
    if SV.ChapterProgression.Chapter < 4 then
		GeneralFunctions.StartConversation(chara, "Désolé,[pause=10] mais seules les équipes de rang[color=#FFA5FF]Bronze[color]ou supérieur peuvent utiliser les services ici.")
		state = -1
	else
		--Reimplement parts of StartConversation
			local hero = CH('PLAYER')
			local partner = CH('Teammate1')
			chara.IsInteracting = true
			partner.IsInteracting = true
			SV.TemporaryFlags.OldDirection = chara.Direction
			GROUND:CharSetAnim(partner, 'None', true)
			GROUND:CharSetAnim(hero, 'None', true)

			GROUND:CharTurnToChar(hero, chara)
			GROUND:CharTurnToChar(chara, hero)
			local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	end


	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Connect_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Connect_Intro_Return'])
			end

			local end_choice = 5
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Connect'])
			connect_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Server'])
			-- connect_choices[3] = "Connect Peer-to-Peer"
			connect_choices[4] = STRINGS:FormatKey("MENU_INFO")
			connect_choices[5] = STRINGS:FormatKey("MENU_EXIT")

			UI:BeginChoiceMenu(msg, connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if GAME:HasServerSet() then
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_No_Server']))
				end
			elseif result == 2 then
				UI:ServersMenu()
				UI:WaitForChoice()
			elseif result == 3 then
				state = 4
			elseif result == 4 then
				state = 7
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ContactsMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			UI:ShowConnectMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 3
			else
				state = 1
			end
		elseif state == 3 then
			UI:CurrentActivityMenu()
			UI:WaitForChoice()
			state = 1
		elseif state == 4 then
			UI:PeersMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 5
			else
				state = 0
			end
		elseif state == 5 then
			UI:ShowConnectMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 6
			else
				state = 4
			end
		elseif state == 6 then
			UI:CurrentActivityMenu()
			UI:WaitForChoice()
			state = 4
		elseif state == 7 then
			local end_choice = 6
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Friends'])
			connect_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Teammate'])
			connect_choices[3] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Treasure'])
			-- connect_choices[4] = "Mail Exchange"
			connect_choices[5] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Advanced'])
			connect_choices[6] = STRINGS:FormatKey("MENU_CANCEL")

				-- Connecting Peer-to-Peer
				-- File Rescue
				-- Hosting a Server

			UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Ask']), connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_004']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_004']))
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Item_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Item_002']))
			elseif result == 4 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Mail_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Mail_002']))
			elseif result == 5 then
				state = 8
			else
				state = 0
			end
		elseif state == 8 then
			local end_choice = 3
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_P2P'])
			connect_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Host'])
			connect_choices[3] = STRINGS:FormatKey("MENU_CANCEL")

			UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Ask']), connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_005']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_006']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_007']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_008']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_009']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Server_Host_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Server_Host_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Server_Host_003']))
			else
				state = 7
			end
		end
	end

	--Catching the partner's turnto coroutine from the dialogue start
	if coro1 ~= nil then TASK:JoinCoroutines({coro1}) end

	GeneralFunctions.EndConversation(chara)
end

function post_office.Side_Desk_Action(obj, activator)
	local chara = CH('Rescue_Owner')
	local state = 0
    local sos = nil
    local repeated = false
    UI:SetSpeaker(chara)

	--Only allow players the ability to go on rescues when they're bronze rank (They've started chapter 4)
    if SV.ChapterProgression.Chapter < 4 then
		GeneralFunctions.StartConversation(chara, "Désolé,[pause=10] mais seules les équipes de rang[color=#FFA5FF]Bronze[color]ou supérieur peuvent utiliser les services ici.")
		state = -1
	else
		--Reimplement parts of StartConversation
			local hero = CH('PLAYER')
			local partner = CH('Teammate1')
			chara.IsInteracting = true
			partner.IsInteracting = true
			SV.TemporaryFlags.OldDirection = chara.Direction
			GROUND:CharSetAnim(partner, 'None', true)
			GROUND:CharSetAnim(hero, 'None', true)

			GROUND:CharTurnToChar(hero, chara)
			GROUND:CharTurnToChar(chara, hero)
			local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	end

	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Rescue_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Rescue_Intro_Return'])
			end

			local connect_choices = {STRINGS:Format(STRINGS.MapStrings['Rescue_Option_SOS']),
			STRINGS:Format(STRINGS.MapStrings['Rescue_Option_AOK']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, connect_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if GAME:HasSOSMail() then
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_SOS_None']))
				end
			elseif result == 2 then
				if GAME:HasAOKMail() then
					UI:AOKMenu()
					UI:WaitForChoice()
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_AOK_None']))
				end
			elseif result == 3 then
				state = 3
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:SOSMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result ~= nil then
				sos = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local mail = RogueEssence.Data.DataManager.LoadRescueMail(sos)
			--The player can only go on rescues for dungeons they have completed themselves.
			local dungeon = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(mail.Goal.ID)
			if _DATA.Save:GetDungeonUnlock(mail.Goal.ID) == RogueEssence.Data.GameProgress.UnlockState.Completed then
				UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['Rescue_Confirm'], dungeon:GetColoredName()), false)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result then
					state = -1
				else
					sos = nil
					state = 1
				end
			else
				UI:WaitShowDialogue("Désolé,[pause=10] mais il semble que vous n'ayez pas encore complètement exploré " .. dungeon:GetColoredName() .. ".")
				UI:WaitShowDialogue("Nous ne pouvons pas vous permettre de partir en sauvetage dans un endroit que vous n'avez pas correctement terminé !")
				UI:WaitShowDialogue("Je m'excuse,[pause=10]mais votre ami devra simplement attendre que vous l'ayez terminé.")
				sos = nil
				state = 1
			end
		elseif state == 3 then
			local end_choice = 3
			local info_choices = {}
			info_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Friend_Rescue'])
			info_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_File_Rescue'])
			info_choices[3] = STRINGS:FormatKey("MENU_CANCEL")
			UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Ask']), info_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_005']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_006']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_Rescue_007']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_005']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_006']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_007']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Info_File_Rescue_008']))
			else
				state = 0
			end
		end
	end

	if sos ~= nil then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Begin']))
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)
		GAME:WaitFrames(20)
		-- begin rescue mission
		GAME:EnterRescue(sos)
	end

	--Catching the partner's turnto coroutine from the dialogue start
	if coro1 ~= nil then TASK:JoinCoroutines({coro1}) end

	GeneralFunctions.EndConversation(chara)
end

--[[
function post_office.Main_Desk_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  --TODO: rank calc
  --Stars:
  --Complete all dungeons
  --Complete dex
  --Complete Rogue
  --Reach 100F of neverending tale
  --Reach Lv100 with founder

  local state = 0
  local repeated = false
  local chara = CH('Connect_Owner')
  UI:SetSpeaker(chara)

	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Connect_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Connect_Intro_Return'])
			end

			local end_choice = 5
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Connect'])
			connect_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Server'])
			-- connect_choices[3] = "Connect Peer-to-Peer"
			connect_choices[4] = STRINGS:FormatKey("MENU_INFO")
			connect_choices[5] = STRINGS:FormatKey("MENU_EXIT")

			UI:BeginChoiceMenu(msg, connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if GAME:HasServerSet() then
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_No_Server']))
				end
			elseif result == 2 then
				UI:ServersMenu()
				UI:WaitForChoice()
			elseif result == 3 then
				state = 4
			elseif result == 4 then
				state = 7
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ContactsMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			UI:ShowConnectMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 3
			else
				state = 1
			end
		elseif state == 3 then
			UI:CurrentActivityMenu()
			UI:WaitForChoice()
			state = 1
		elseif state == 4 then
			UI:PeersMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 5
			else
				state = 0
			end
		elseif state == 5 then
			UI:ShowConnectMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 6
			else
				state = 4
			end
		elseif state == 6 then
			UI:CurrentActivityMenu()
			UI:WaitForChoice()
			state = 4
		elseif state == 7 then
			local end_choice = 7
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Friends'])
			connect_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Friend_Rescue'])
			connect_choices[3] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Teammate'])
			connect_choices[4] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Treasure'])
			-- connect_choices[5] = "Mail Exchange"
			connect_choices[6] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Advanced'])
			connect_choices[7] = STRINGS:FormatKey("MENU_CANCEL")

				-- Connecting Peer-to-Peer
				-- File Rescue
				-- Hosting a Server

			UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Ask']), connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Friends_004']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_005']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_006']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Rescue_007']))
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Team_004']))
			elseif result == 4 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Item_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Item_002']))
			elseif result == 5 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Mail_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Trade_Mail_002']))
			elseif result == 6 then
				state = 8
			else
				state = 0
			end
		elseif state == 8 then
			local end_choice = 4
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_P2P'])
			connect_choices[2] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_File_Rescue'])
			connect_choices[3] = STRINGS:Format(STRINGS.MapStrings['Connect_Option_Host'])
			connect_choices[4] = STRINGS:FormatKey("MENU_CANCEL")

			UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Ask']), connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_005']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_006']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_007']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_008']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_P2P_009']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_004']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_005']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_006']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_007']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_File_Rescue_008']))
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Server_Host_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Server_Host_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Connect_Info_Server_Host_003']))
			else
				state = 7
			end
		end
	end
end

function post_office.Side_Desk_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local sos = nil
  local repeated = false
  local chara = CH('Rescue_Owner')
  UI:SetSpeaker(chara)

	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Rescue_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Rescue_Intro_Return'])
			end

			local connect_choices = {STRINGS:Format(STRINGS.MapStrings['Rescue_Option_SOS']),
			STRINGS:Format(STRINGS.MapStrings['Rescue_Option_AOK']),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, connect_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if GAME:HasSOSMail() then
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_SOS_None']))
				end
			elseif result == 2 then
				if GAME:HasAOKMail() then
					UI:AOKMenu()
					UI:WaitForChoice()
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_AOK_None']))
				end
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:SOSMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result ~= nil then
				sos = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local mail = RogueEssence.Data.DataManager.LoadRescueMail(sos);
			local dungeon = RogueEssence.Data.DataManager.Instance:GetZone(mail.Goal.ID)
			UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['Rescue_Confirm'], dungeon.Name:ToLocal()), false)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result then
				state = -1
			else
				sos = nil
				state = 1
			end
		end
	end

	if sos ~= nil then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Rescue_Begin']))
		GAME:FadeOut(false, 20)
		-- begin rescue mission
		GAME:EnterRescue(sos)
	end
end
]]--


function post_office.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return post_office
