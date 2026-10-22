require 'origin.common'

require "halcyon.CharacterEssentials"

RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')
DmgMultType = luanet.import_type('PMDC.Dungeon.DmgMult')


function BATTLE_SCRIPT.ShopkeeperInteract(owner, ownerChar, context, args)

  if COMMON.CanTalk(context.Target) then
	local security_state = COMMON.GetShopPriceState()
    local price = security_state.Cart
    local sell_price = COMMON.GetDungeonSellPrice()

    local oldDir = context.Target.CharDir
    DUNGEON:CharTurnToChar(context.Target, context.User)

    if sell_price > 0 then
      context.TurnCancel.Cancel = true
      UI:SetSpeaker(context.Target)
	  UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_%04d", context.Target.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", sell_price)), false)
	  UI:WaitForChoice()
	  result = UI:ChoiceResult()

	  if SV.adventure.Thief then
	    COMMON.ThiefReturn()
	  elseif result then
	    -- iterate player inventory prices and remove total price
        COMMON.PayDungeonSellPrice(sell_price)
	    SOUND:PlayBattleSE("DUN_Money")
	    UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_DONE_%04d", context.Target.Discriminator)):ToLocal())
	  else
	    -- nothing
	  end
    end

    if price > 0 then
      context.TurnCancel.Cancel = true
      UI:SetSpeaker(context.Target)
	  UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_%04d", context.Target.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", price)), false)
	  UI:WaitForChoice()
	  result = UI:ChoiceResult()
	  if SV.adventure.Thief then
	    COMMON.ThiefReturn()
	  elseif result then
	    if price > GAME:GetPlayerMoney() then
          UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", context.Target.Discriminator)):ToLocal())
	    else
	      -- iterate player inventory prices and remove total price
          COMMON.PayDungeonCartPrice(price)
	      SOUND:PlayBattleSE("DUN_Money")
	      UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", context.Target.Discriminator)):ToLocal())
	    end
	  else
	    UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_REFUSE_%04d", context.Target.Discriminator)):ToLocal())
	  end
    end

	if price == 0 and sell_price == 0 then
      context.CancelState.Cancel = true
      UI:SetSpeaker(context.Target)
	  --Halcyon tweak: If you talk to kec or enter his shop after stealing, he'll aggro you
	  if SV.adventure.Thief then
		COMMON.ThiefReturn()
	  else
		UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_%04d", context.Target.Discriminator)):ToLocal())
		context.Target.CharDir = oldDir
	  end
	end
  else

    UI:ResetSpeaker()

	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", context.Target:GetDisplayName(true))
    UI:WaitShowDialogue(chosen_quote)
  end
end

function BATTLE_SCRIPT.EscortInteract(owner, ownerChar, context, args)
  context.CancelState.Cancel = true
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)

  --Basic for now, but choose a different line based on mission type/special
  --Should be expanded on in the future to be more dynamic, and to have more special lines for special pairs
  local tbl = LTBL(context.Target)
  local mission_slot = tbl.Escort
  local job = SV.TakenBoard[mission_slot]

  if job.Type == COMMON.MISSION_TYPE_EXPLORATION then
		local floor = MISSION_GEN.STAIR_TYPE[job.Zone] .. '[color=#00FFFF]' .. tostring(job.Floor) .. '[color]' .. "F"
		UI:WaitShowDialogue("S'il vous plaît, emmenez-moi à " .. floor .. " !")
  elseif job.Type == COMMON.MISSION_TYPE_ESCORT then
    if job.Special == MISSION_GEN.SPECIAL_CLIENT_LOVER then
	  UI:WaitShowDialogue("S'il te plaît, amène-moi à mon amour ! Je compte sur toi !")
	else
	  UI:WaitShowDialogue("Je compte sur vous pour m'amener à " .. _DATA:GetMonster(job.Target):GetColoredName() .. " !")
	end
   end
  context.Target.CharDir = oldDir
end

function BATTLE_SCRIPT.RescueReached(owner, ownerChar, context, args)
	-- Set the nickname of the target, removing the gender sign
	local base_name = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:Get(context.Target.BaseForm.Species).Name:ToLocal()
	GAME:SetCharacterNickname(context.Target, base_name)

	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true

	local targetName = _DATA:GetMonster(context.Target.BaseForm.Species):GetColoredName()

  local oldDir = context.Target.CharDir

	local tbl = LTBL(context.Target)
	local mission = SV.TakenBoard[tbl.Mission]
  DUNGEON:CharTurnToChar(context.Target, context.User)
	UI:ResetSpeaker()

	if mission.Type == COMMON.MISSION_TYPE_RESCUE then
		RescueCheck(context, targetName, mission)
	elseif mission.Type == COMMON.MISSION_TYPE_DELIVERY then
		DeliveryCheck(context, targetName, mission)
	end
end

function RescueCheck(context, targetName, mission)
	UI:ChoiceMenuYesNo("Oui! Vous avez trouvé " .. targetName .. " !\nVoulez-vous utiliser votre badge pour sauver " .. targetName .. " ?", false)
	UI:WaitForChoice()
	local use_badge = UI:ChoiceResult()
	if use_badge then
		--Mark mission completion flags
		SV.TemporaryFlags.MissionCompleted = true
		--Clear but remember minimap state
		SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
		_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
		GAME:WaitFrames(20)
		mission.Completion = 1
		UI:WaitShowDialogue("Votre badge brille sur " .. targetName .. " et " .. targetName .. " est transporté comme par magie !")
		GAME:WaitFrames(20)
		UI:SetSpeaker(context.Target)

		--different responses for special targets
		if mission.Special == MISSION_GEN.SPECIAL_CLIENT_CHILD then
			GeneralFunctions.SetEmotion("Joyous")
			UI:WaitShowDialogue("Merci de m'avoir sauvé ! Cet endroit était tellement effrayant ! J'ai hâte de revoir ma famille !")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_FRIEND then
			UI:WaitShowDialogue("Oh, mon ami t'a envoyé pour me sauver ? Dieu merci! Nous vous reverrons à la guilde plus tard pour vous remercier !")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_RIVAL then
			UI:WaitShowDialogue("Tch, mon rival t'a envoyé pour me sauver, hein ? Eh bien, merci. Nous vous récompenserons plus tard à la guilde.")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_LOVER then
			GeneralFunctions.SetEmotion("Joyous")
			UI:WaitShowDialogue("Oh, mon bien-aimé " .. _DATA:GetMonster(mission.Client):GetColoredName() .. " vous a envoyé pour me sauver ? J'ai hâte de les retrouver !")
		else
			UI:WaitShowDialogue("Merci pour le sauvetage !\nJe vous verrai à la guilde après avec votre récompense !")
			end
		GAME:WaitFrames(20)
		UI:ResetSpeaker()
		UI:WaitShowDialogue(targetName .. " s'est échappé du donjon !")
		GAME:WaitFrames(20)
		-- warp out
		TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
		_DUNGEON:RemoveChar(context.Target)
		GAME:WaitFrames(50)
		GeneralFunctions.AskMissionWarpOut()
	else
		--quickly hide the minimap for the 20 frame pause
		local map_setting = _DUNGEON.ShowMap
		_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
		GAME:WaitFrames(20)
		UI:SetSpeaker(context.Target)
		if mission.Special == MISSION_GEN.SPECIAL_CLIENT_CHILD then
			GeneralFunctions.SetEmotion("Crying")
			UI:WaitShowDialogue("Waaah ! C'est effrayant ici ! P-s'il vous plaît, aidez-moi !")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_FRIEND then
			GeneralFunctions.SetEmotion("Surprised")
			UI:WaitShowDialogue("S'il vous plaît, ne me laissez pas ici ! Mon ami est probablement malade d'inquiétude !")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_RIVAL then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Woah, ne me laisse pas traîner ici !")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_LOVER then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("S'il vous plaît, sortez-moi d'ici ! Je veux juste revoir mon cher " .. _DATA:GetMonster(mission.Client):GetColoredName() .. " !")
		else
			GeneralFunctions.SetEmotion("Surprised")
			UI:WaitShowDialogue("H-hé ! Ne me laisse pas ici !")
		end
		--change map setting back to what it was
		_DUNGEON.ShowMap = map_setting
		GAME:WaitFrames(20)
	end
end

function DeliveryCheck(context, targetName, mission)
	local inv_slot = GAME:FindPlayerItem(mission.Item, false, true)
	local team_slot = GAME:FindPlayerItem(mission.Item, true, false)
	local has_item = inv_slot:IsValid() or team_slot:IsValid()
	local item_name =  RogueEssence.Dungeon.InvItem(mission.Item):GetDisplayName()

	if has_item then
		UI:ChoiceMenuYesNo("Oui! Vous avez localisé " .. targetName .. " ! Voulez-vous livrer le " .. item_name .. " demandé à " .. targetName .. " ?")
		UI:WaitForChoice()
		local deliver_item = UI:ChoiceResult()
		if deliver_item then
			SV.TemporaryFlags.MissionCompleted = true
			mission.Completion = 1
			--Clear but remember minimap state
			SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			-- Take from inventory first before held items
			if inv_slot:IsValid() then
				GAME:TakePlayerBagItem(inv_slot.Slot, true)
			else
				GAME:TakePlayerEquippedItem(team_slot.Slot, true)
			end
			GAME:WaitFrames(20)
			UI:SetSpeaker(context.Target)
			UI:WaitShowDialogue("Merci pour le " .. item_name .. " !\n Je vous verrai à la guilde après avec votre récompense !")
			GAME:WaitFrames(20)
			UI:ResetSpeaker()
			UI:WaitShowDialogue(targetName .. " s'est échappé du donjon !")
			GAME:WaitFrames(20)
			TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
			_DUNGEON:RemoveChar(context.Target)
			GAME:WaitFrames(50)
			GeneralFunctions.AskMissionWarpOut()
		else --they are sad if you dont give them the item
			--quickly hide the minimap for the 20 frame pause
			local map_setting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			GAME:WaitFrames(20)
			UI:SetSpeaker(context.Target)
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Oh, s'il te plaît ! J'ai vraiment besoin de ce " .. item_name .. "...")
			--change map setting back to what it was
			_DUNGEON.ShowMap = map_setting
			GAME:WaitFrames(20)		end
	else
		UI:WaitShowDialogue("Le " .. item_name .. " demandé n'est pas dans le sac au trésor.\nIl n'y a rien à livrer.")
		--quickly hide the minimap for the 20 frame pause
		local map_setting = _DUNGEON.ShowMap
		_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
		GAME:WaitFrames(20)
		UI:SetSpeaker(context.Target)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue("Hein, tu n'as pas le " .. item_name .. " ? C'est dommage...")
		--change map setting back to what it was
		_DUNGEON.ShowMap = map_setting
		GAME:WaitFrames(20)
	end
end

function BATTLE_SCRIPT.EscortRescueReached(owner, ownerChar, context, args)
	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true
  --Mark this as the last dungeon entered.
  local tbl = LTBL(context.Target)
	if tbl ~= nil and tbl.Mission ~= nil then
		local mission = SV.TakenBoard[tbl.Mission]
		local escort = COMMON.FindMissionEscort(tbl.Mission)
		local escortName = _DATA:GetMonster(mission.Client):GetColoredName()
		if escort then
			local oldDir = context.Target.CharDir
			DUNGEON:CharTurnToChar(context.Target, context.User)
			UI:ResetSpeaker()
			if math.abs(escort.CharLoc.X - context.Target.CharLoc.X) <= 4 and math.abs(escort.CharLoc.Y - context.Target.CharLoc.Y) <= 4 then
				--Mark mission completion flags
				SV.TemporaryFlags.MissionCompleted = true
				mission.Completion = 1
				UI:WaitShowDialogue("Oui! Vous avez terminé la mission d'escorte de " .. escortName .. ".\n" .. escortName .. " est ravi !")
				--Clear but remember minimap state
				SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
				_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
				GAME:WaitFrames(20)

				UI:SetSpeaker(escort)
				UI:WaitShowDialogue("Merci de m'avoir accompagné jusqu'à " .. _DATA:GetMonster(context.Target.CurrentForm.Species):GetColoredName() .. " !")
				GAME:WaitFrames(20)
				UI:ResetSpeaker()
				UI:WaitShowDialogue("Le duo de " .. escortName .. " a quitté le donjon !")
				GAME:WaitFrames(20)

				--Set max team size to 4 as the guest is no longer "taking" up a party slot
				RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 4

				-- warp out
				TASK:WaitTask(_DUNGEON:ProcessBattleFX(escort, escort, _DATA.SendHomeFX))
				_DUNGEON:RemoveChar(escort)
				_ZONE.CurrentMap.DisplacedChars:Remove(escort)
				GAME:WaitFrames(70)
				TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
				_DUNGEON:RemoveChar(context.Target)

				GAME:WaitFrames(50)
				GeneralFunctions.AskMissionWarpOut()
			else
				UI:WaitShowDialogue(escortName .. " ne semble pas être là...")
			end
		end
  end
end




--Use this in Interact scripts to replace wildcards, then return a chosen string from the personality with wildcards replaced.
function ChooseQuote(chara, target, key, running_pool, mission)
	local valid_quote = false
	local chosen_quote = ""

	--For mission relevant quotes. This feels like kinda a bad implementation since it's a copy and paste
	--of something being done already in the PartnerInteract, but... Oh well? This is the simplest/cleanest way i could think of handling it in this subfunction.
	--TODO: Reevaluate down the road potentially a cleaner way? Probably not needed.
	local tbl = LTBL(target)
	local outlaw = nil
	local rescuee = nil
	local mission = nil
	local objective_item = nil
	local escort = tbl.EscortMissionNum
	if tbl.MissionNumber ~= nil then
		mission = SV.TakenBoard[tbl.MissionNumber]
		if tbl.MissionType == COMMON.MISSION_BOARD_MISSION then
			rescuee = COMMON.FindNpcWithTable(false, "Mission", tbl.MissionNumber)
		elseif tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
			outlaw = COMMON.FindNpcWithTable(true, "Mission", tbl.MissionNumber)
		end

		if mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then
			objective_item = mission.Item
		end
	end





    while not valid_quote and #running_pool > 0 do
	  valid_quote = true
      local chosen_idx = math.random(1, #running_pool)
  	  local chosen_pool_idx = running_pool[chosen_idx]

	  --for use with [(name)] replacing
	  local char_list = {}
	  local char_count = 0

      chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()

	  --[(stuff)] indicates that the item inside (in this case stuff) is a pokemon's identifer and should be fed to CharacterEssentials to get their name. THANKS NO NICKNAME ENTHUSIASTS I HATE YOU
	  --NOTE/TODO: This breaks for characters who have _ (or other special chars) in their character call name. If this situation pops up, either address it here or remove the underscore from all instances of that character call name.
	  for i in string.gmatch(chosen_quote, "%[%((%a+)%)%]") do
		char_count = char_count + 1
		char_list[char_count] = i
	  end

	  for i = 1, #char_list, 1 do
		chosen_quote = string.gsub(chosen_quote, "%[%(" .. char_list[i] .. "%)%]", CharacterEssentials.GetCharacterName(char_list[i]))
	  end

      chosen_quote = string.gsub(chosen_quote, "%[player%]", chara:GetDisplayName(true))
      chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

	  --These are tags that should show up at the very start of the string, though it doesn't matter where you place them.
	  --Check for a tag in the style of [{POKEMON_NAME}], given as the species.
	  --So if a tag exists in the string, check if our current character is tagged. If they are, they can view the line. If they aren't, they can't view the line.
	  --If no tag in this manner exists for the string, then any character can view the line.
	  local chara_tbl = LTBL(chara)
	  if string.find(chosen_quote, "%[%{(%a+)%}%]") then
		valid_quote = false
		if string.find(chosen_quote, "%[%{" .. chara_tbl.Importance .. "%}%]") then
			valid_quote = true
		end
		--remove any of these types of tags once we're done checking them.
		chosen_quote = string.gsub(chosen_quote, "%[%{(%a+)%}%]", "")
	  end
	  --Remove all instances of a single character enclosed in a bracket, as they're just used for the above tagging.
	  chosen_quote = string.gsub(chosen_quote, "%[%a%]", "")



	  --For naming specific characters in the given slot in the party. Useful when color tagging is relevant!
	  --Given slot1, it will put character in slot1's name instead.
	  if string.find(chosen_quote, "%[slot") then
		  for i = 1, GAME:GetPlayerPartyCount(), 1 do
			chosen_quote = string.gsub(chosen_quote, "%[slot" .. tostring(i) .. "%]", GAME:GetPlayerPartyMember(i-1):GetDisplayName(true))
		  end
	  end

      if string.find(chosen_quote, "%[move%]") then
        local moves = {}
  	    for move_idx = 0, 3 do
  	      if target.BaseSkills[move_idx].SkillNum ~= "" then
  	        table.insert(moves, target.BaseSkills[move_idx].SkillNum)
  	      end
  	    end
  	    if #moves > 0 then
  	      local chosen_move = _DATA:GetSkill(moves[math.random(1, #moves)])
  	      chosen_quote = string.gsub(chosen_quote, "%[move%]", chosen_move:GetIconName())
  	    else
  	      valid_quote = false
  	    end
      end

      if string.find(chosen_quote, "%[kind%]") then
  	    if GAME:GetCurrentFloor().TeamSpawns.CanPick then
          local team_spawn = GAME:GetCurrentFloor().TeamSpawns:Pick(GAME.Rand)
  	      local chosen_list = team_spawn:ChooseSpawns(GAME.Rand)
  	      if chosen_list.Count > 0 then
  	        local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
  	        local mon = _DATA:GetMonster(chosen_mob.BaseForm.Species)
            chosen_quote = string.gsub(chosen_quote, "%[kind%]", mon:GetColoredName())
  	      else
  	        valid_quote = false
  	      end
  	    else
  	      valid_quote = false
  	    end
      end

      if string.find(chosen_quote, "%[item%]") then
        if GAME:GetCurrentFloor().ItemSpawns.CanPick then
          local item = GAME:GetCurrentFloor().ItemSpawns:Pick(GAME.Rand)
          chosen_quote = string.gsub(chosen_quote, "%[item%]", item:GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end


      if string.find(chosen_quote, "%[mission_client%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(mission.Client):GetColoredName())
		elseif escort ~= nil then
		    chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(SV.TakenBoard[escort].Client):GetColoredName())
  	    else
  	      valid_quote = false
  	    end
      end

	   if string.find(chosen_quote, "%[mission_target%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(mission.Target):GetColoredName())
  	   	elseif escort ~= nil then
		  chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(SV.TakenBoard[escort].Target):GetColoredName())
        else
  	      valid_quote = false
  	    end
      end


	  if string.find(chosen_quote, "%[mission_item%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_item%]", RogueEssence.Dungeon.InvItem(mission.Item):GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end



  	  if not valid_quote then
        PrintInfo("Rejected "..chosen_quote)
  	    table.remove(running_pool, chosen_idx)
  	    chosen_quote = ""
  	  end

    end
    PrintInfo("Selected "..chosen_quote .. " from pool of " .. tostring(#running_pool))
	return chosen_quote
end

--special Halcyon script for the partner
function BATTLE_SCRIPT.PartnerInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel

	action_cancel.Cancel = true

  if COMMON.CanTalk(target) then

    UI:SetSpeaker(target)

    local ratio = target.HP * 100 // target.MaxHP

    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]

	--Partner has a different personality for each pool of quotes, with pools having different quotes to have additional comments on specific plotstate.
	--If no special quotes are needed because you're not doing the current story dungeon or whatever, use the default partner personality of 51.

    local personality = 51

	local dungeon = GAME:GetCurrentDungeon().Name:ToLocal()
	local segment = _ZONE.CurrentMapID.Segment

	local tbl = LTBL(target)
	local outlaw = nil
	local rescuee = nil
	local mission = nil
	local objective_item = nil
	local escort = tbl.EscortMissionNum
	if tbl.MissionNumber ~= nil then
		mission = SV.TakenBoard[tbl.MissionNumber]
		if tbl.MissionType == COMMON.MISSION_BOARD_MISSION then
			rescuee = COMMON.FindNpcWithTable(false, "Mission", tbl.MissionNumber)
		elseif tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
			outlaw = COMMON.FindNpcWithTable(true, "Mission", tbl.MissionNumber)
		end

		if mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then
			objective_item = mission.Item
		end
	end
	PrintInfo(tostring(rescuee))
	PrintInfo(tostring(outlaw))
	PrintInfo(tostring(tbl.MissionNumber))
	PrintInfo(tostring(tbl.EscortMissionNum))



	if rescuee ~= nil then--comment on rescue target
		if mission.Type == COMMON.MISSION_TYPE_RESCUE then
			personality = 52
		elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 53
		elseif mission.Type == COMMON.MISSION_TYPE_DELIVERY then
			local inv_slot = GAME:FindPlayerItem(mission.Item, false, true)
			local team_slot = GAME:FindPlayerItem(mission.Item, true, false)
			local has_item = inv_slot:IsValid() or team_slot:IsValid()
			--partner comments change depending on whether you actually have the delivery item or not
			if has_item then
				personality = 54
			else
				GeneralFunctions.SetEmotion("Worried")
				personality = 55
			end
		end
	elseif outlaw ~= nil then--comment on outlaw target
		personality = 59
		GeneralFunctions.SetEmotion("Determined")--this is overriden to worried/pain if hp is low enough
	elseif objective_item ~= nil and mission.Completion == COMMON.MISSION_INCOMPLETE then --comment on needing to find the item
		personality = 56
	elseif escort ~= nil and SV.TakenBoard[escort].Completion == COMMON.MISSION_INCOMPLETE then
		if SV.TakenBoard[escort].Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 57
		else
			personality = 58
		end
	else
		--Story personalities
		--BUG CORRIGE : ces branches comparaient `dungeon`, qui vient de
		--GAME:GetCurrentDungeon().Name:ToLocal() — donc le nom TRADUIT
		--(Text.cs:1052-1067) — a des litteraux anglais. En francais,
		--`dungeon` vaut « Foret des Reliques », jamais « Relic Forest » :
		--aucune de ces conditions ne pouvait etre vraie, et le partenaire
		--retombait toujours sur la personnalite generique 51.
		--On compare desormais l'ID interne de zone, invariant par langue.
		if SV.ChapterProgression.Chapter == 1 and zone_id == 'relic_forest' then
			personality = 60
		elseif SV.ChapterProgression.Chapter == 2 and zone_id == 'illuminant_riverbed' then
			personality = 61
		elseif SV.ChapterProgression.Chapter == 3 and zone_id == 'crooked_cavern' then
			if not SV.Chapter3.EncounteredBoss and segment == 0 then --dungeon, havent fought boss yet
				personality = 62
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 0 then --dungeon, lost to boss already
				personality = 63
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 1 then
				personality = 64
				GeneralFunctions.SetEmotion("Determined")--this is overriden to worried/pain if hp is low enough
			end
		elseif SV.ChapterProgression.Chapter == 4 and zone_id == 'apricorn_grove' then
			if not SV.Chapter4.ReachedGlade then
				personality = 65
			elseif not SV.Chapter4.FinishedGrove then
				personality = 66
			end
		elseif zone_id == 'mount_windswept' then
			--EXPEDITION — Mont Venteux. Le partenaire n'avait aucune
			--personnalite au-dela du chapitre 4 : il commentait le Mont
			--avec les repliques generiques de la guilde. Segments :
			--  0 = 1re moitie, 1 = Defile (mini-boss),
			--  2 = Cretes,     3 = Sommet (gardien).
			if segment == 1 or segment == 3 then
				personality = 332
				GeneralFunctions.SetEmotion("Determined")
			elseif segment == 2 then
				personality = 331
			elseif segment == 0 then
				personality = 330
			end
		end
	end
	PrintInfo("Personality in use: " .. tostring(personality))

    local personality_group = COMMON.PERSONALITY[personality]
    local pool = {}
    local key = ""
    if ratio <= 25 then
      GeneralFunctions.SetEmotion("Pain")
      pool = personality_group.PINCH
      key = "TALK_PINCH_%04d"
    elseif ratio <= 50 then
      GeneralFunctions.SetEmotion("Worried")
      pool = personality_group.HALF
      key = "TALK_HALF_%04d"
    else
      pool = personality_group.FULL
      key = "TALK_FULL_%04d"
    end

    local running_pool = {table.unpack(pool)}
    local valid_quote = false
    local chosen_quote = ""

	--Choose a quote, replacing wildcards in the process.
    chosen_quote = ChooseQuote(chara, target, key, running_pool)

	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)


    UI:WaitShowDialogue(chosen_quote)

    target.CharDir = oldDir
  else

    UI:ResetSpeaker()

	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

    UI:WaitShowDialogue(chosen_quote)

  end
end





--special Halcyon interact script for the hero
--very simplified version of partner script, only dialogue possible is "(.........)"
function BATTLE_SCRIPT.HeroInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel

    UI:SetSpeaker(target)

	action_cancel.Cancel = true
  -- TODO: create a charstate for being unable to talk and have talk-interfering statuses cause it
  if target:GetStatusEffect("sleep") == nil and target:GetStatusEffect("freeze") == nil then

    local ratio = target.HP * 100 // target.MaxHP

    if ratio <= 25 then
      GeneralFunctions.SetEmotion("Pain")
    elseif ratio <= 50 then
      GeneralFunctions.SetEmotion("Worried")
    else
	  GeneralFunctions.SetEmotion("Normal")
    end

    local chosen_quote = ""



	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)

	chosen_quote = '(.........)'

    UI:WaitShowDialogue(chosen_quote)

    target.CharDir = oldDir
  else

    UI:ResetSpeaker()

	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

    UI:WaitShowDialogue(chosen_quote)

  end
end

--custom Halcyon script for Ledian, the dojomaster/sensei, for use during dojo lessons (tutorials)
function BATTLE_SCRIPT.SenseiInteract(owner, ownerChar, context, args)
	local chara = context.User--player
	local target = context.Target--ledian
	UI:SetSpeaker(target)

	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true

	local olddir = target.CharDir
	DUNGEON:CharTurnToChar(target, chara)
	UI:BeginChoiceMenu("As-tu besoin de quelque chose,[pause=10]mon élève ?", {"Help", "Reset floor", "Nothing"}, 3, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then
		args.Speech = SV.Tutorial.Progression
		SV.Tutorial.Progression = -1 --temporarily clear progression flag so speech can happen. -1 to prevent pausing before script trigger
		BeginnerLessonSpeechHelper(owner, ownerChar, target, args)
	elseif result == 2 then
		UI:WaitShowDialogue("Wahtah![pause=0]Très bien![pause=0]Permettez-moi de réinitialiser cet étage !")
		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Determined")
		--charging animation
		DUNGEON:CharStartAnim(target, "Charge", true)
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		DUNGEON:CharEndAnim(target)
		GeneralFunctions.SetEmotion("Shouting")
		--setup flashes
		local emitter = RogueEssence.Content.FlashEmitter()
		emitter.FadeInTime = 2
		emitter.HoldTime = 4
		emitter.FadeOutTime = 2
		emitter.StartColor = Color(0, 0, 0, 0)
		emitter.Layer = DrawLayer.Top
		emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
		--setup hop animation
		local action = RogueEssence.Dungeon.CharAnimAction()
		action.BaseFrameType = 43 --hop
		action.AnimLoc = target.CharLoc
		action.CharDir = target.CharDir
		TASK:WaitTask(target:StartAnim(action))

		DUNGEON:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
	    GAME:WaitFrames(15)
	    DUNGEON:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
		UI:WaitShowTimedDialogue("HWACHA!", 40)
		--Reset floor
		local resetEvent = PMDC.Dungeon.ResetFloorEvent()
		local charaContext = RogueEssence.Dungeon.SingleCharContext(chara)
		TASK:WaitTask(resetEvent:Apply(owner, ownerChar, charaContext))
	else
		UI:WaitShowDialogue("Hoiyah![pause=0]En avant la leçon alors !")
	end
end


--Guild member interact script. The logic should be mostly the same between them all,
--so having them in one place (for now at least) is easiest. Personality will change to reflect
--who you're actually talking to.
function BATTLE_SCRIPT.GuildmateInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel

	action_cancel.Cancel = true

  if COMMON.CanTalk(target) then

    UI:SetSpeaker(target)

    local ratio = target.HP * 100 // target.MaxHP

    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]

    local personality = 999--default error personality. 999 has one line, and it's to tell you it's invalid.

	local dungeon = GAME:GetCurrentDungeon().Name:ToLocal()
	local segment = _ZONE.CurrentMapID.Segment
	--IDENTIFIANT INTERNE de la zone, et non son nom affiche.
	--`dungeon` ci-dessus passe par LocalText:ToLocal() (Text.cs:1052),
	--qui rend la traduction : en francais il vaut « Mont Venteux », pas
	--« Mt. Windswept ». Comparer un nom localise a un litteral anglais
	--ne matche jamais hors anglais. On route donc sur l'ID de zone,
	--stable quelle que soit la langue.
	local zone_id = tostring(_ZONE.CurrentZoneID)


	local target_tbl = LTBL(target)
	local target_importance = target_tbl.Importance

	--Check story flags and also the species of the char to figure out who's talking and what they'd say.
	if SV.ChapterProgression.Chapter == 5 then
		--Expedition arc. Check importance flag that identifies who they are to get personality. Start personalities at 300 for NPCs
		if target_importance == "Snubbull" then
			personality = 300
		elseif target_importance == "Audino" then
			personality = 301
		elseif target_importance == "Growlithe" then
			if segment == 2 then--Boss fight. Dialogue same regardless of boss death status.
				personality = 304
			elseif SV.Chapter5.DiedToBoss then--If in segment 0 or 1, and you've died to the boss, different dialogue.
				personality = 305
			elseif segment == 1 then --second half, didnt die to boss
				personality = 303
			elseif segment == 0 then -- didnt die to boss
				personality = 302
			end
		elseif target_importance == "Zigzagoon" then
			if segment == 2 then--Boss fight. Dialogue same regardless of boss death status.
				personality = 308
			elseif SV.Chapter5.DiedToBoss then--If in segment 0 or 1, and you've died to the boss, different dialogue.
				personality = 309
			elseif segment == 1 then --second half, didnt die to boss
				personality = 307
			elseif segment == 0 then -- didnt die to boss
				personality = 306
			end
		elseif target_importance == "Cranidos" then
			--Run a check to see if Shuca is nearby. If she's next to Ganlon, ganlon acts timid.
			--Additionally, if you're smart enough to use team mode to talk to Ganlon as Shuca, get ANOTHER personality set where he's blushing.
			--Otherwise, Ganlon's an asshole.

			--Shuca should always be in the last party slot.
			local shuca = GAME:GetPlayerPartyMember(3)

			--Check Shuca's health. Ganlon will have different dialogue if she's on critical HP.
			local shucaHealthRatio = shuca.HP * 100 // shuca.MaxHP

			local tbl = LTBL(chara)
			if tbl.Importance == "Mareep" then
				if shucaHealthRatio <= 25 then
					GeneralFunctions.SetEmotion("Sad")
					personality = 314
				else
					GeneralFunctions.SetEmotion("Special1")--Blushing
					personality = 312
				end
			else
				--Check if he's next to shuca if you're not shuca.
				local nextToShuca = false
				if (shuca.CharLoc - target.CharLoc):Dist8() <= 1 and not shuca.Dead then nextToShuca = true end

				if shucaHealthRatio <= 25 then
					GeneralFunctions.SetEmotion("Angry")
					personality = 313--He's mad at you that Shuca's in danger, irrespective of distance between him and Shuca
				elseif nextToShuca then
					personality = 311--timid when next to Shuca
				else
					--PAS DE SHUCA A COTE : Ganlon commente le donjon lui-meme.
					--Les etats relationnels ci-dessus priment toujours ; on ne
					--descend ici que s'il n'y a rien de plus fort a jouer.
					--Segments du Mont (Data/Zone/mount_windswept.json) :
					--  0 = 1re moitie, 1 = Defile (mini-boss),
					--  2 = Cretes,     3 = Sommet (gardien).
					GeneralFunctions.SetEmotion("Determined")
					personality = 310--repli : le fond de caractere, brusque
					if zone_id == "mount_windswept" then
						if segment == 1 or segment == 3 then
							personality = 319--arene de boss
						elseif segment == 2 then
							personality = 318--Cretes
						elseif segment == 0 then
							personality = 317--premiere moitie
						end
					end
				end
			end
		elseif target_importance == "Mareep" then
			local tbl = LTBL(chara)
			if tbl.Importance == "Cranidos" then
				GeneralFunctions.SetEmotion("Happy")
				personality = 316
			else
				personality = 315--repli : Shuca en general
				if zone_id == "mount_windswept" then
					if segment == 1 or segment == 3 then
						personality = 322--arene de boss
					elseif segment == 2 then
						personality = 321--Cretes
					elseif segment == 0 then
						personality = 320--premiere moitie
					end
				end
			end
		end
	else--For chapters down the road

	end
	print("personality: " .. tostring(personality))

    local personality_group = COMMON.PERSONALITY[personality]
    local pool = {}
    local key = ""
    if ratio <= 25 then
      GeneralFunctions.SetEmotion("Pain")
      pool = personality_group.PINCH
      key = "TALK_PINCH_%04d"
    elseif ratio <= 50 then
      GeneralFunctions.SetEmotion("Worried")
      pool = personality_group.HALF
      key = "TALK_HALF_%04d"
    else
      pool = personality_group.FULL
      key = "TALK_FULL_%04d"
    end

    local running_pool = {table.unpack(pool)}
    local valid_quote = false
    local chosen_quote = ""

	--Choose a quote, replacing wildcards in the process.
    chosen_quote = ChooseQuote(chara, target, key, running_pool)

	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)


    UI:WaitShowDialogue(chosen_quote)

    target.CharDir = oldDir
  else

    UI:ResetSpeaker()

	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

    UI:WaitShowDialogue(chosen_quote)

  end
end







function BATTLE_SCRIPT.SynergyScarfAttack(owner, ownerChar, context, args)
	local dmgmult = luanet.ctype(DmgMultType)
	if context.User.EquippedItem.ID == "held_synergy_scarf" then
		--print("Atk " .. ownerChar.Nickname)
		--give multiplycategory status events to boost stats by 10%
		context:AddContextStateMult(dmgmult, false, 11, 10)
	end
end


function BATTLE_SCRIPT.SynergyScarfDefense(owner, ownerChar, context, args)
	local dmgmult = luanet.ctype(DmgMultType)
	if context.Target.EquippedItem.ID == "held_synergy_scarf" then
		--print("Def " .. ownerChar.Nickname)
		--give multiplycategory status events to boost stats by 10%
		context:AddContextStateMult(dmgmult, false, 9, 10)
	end
end

--for information on how this script was made, and things like getting and converting from c# to lua and back, look at these messages between Palika and Audino
--https://discord.com/channels/534207185333256223/575891034949812225/987567409856675950
--note on when to use colon vs period for these types of things :
--Function call (if it uses parentheses) = colon
--Anything else = period
--there are a few exceptions though

function BATTLE_SCRIPT.SynergyScarfPass(owner, ownerChar, context, args)
	local redirection = luanet.ctype(RedirectionType)
	--A “context” stores all the information regarding this battle turn of a particular pokemon, like the fact that an attack critted
	--a turn can be things such as using a move, item, triggering a trap, but not passing a turn or moving. it's a BATTLE context
	--critical health, get a pass scarf event.
	--only pass to an ally who also has a scarf

	if ownerChar.HP <= ownerChar.MaxHP / 4 then

		--Do not redirect attacks that were already redirected
		if (context.ContextStates:Contains(redirection)) then
			return
		end

		if (context.ActionType == RogueEssence.Dungeon.BattleActionType.Trap or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item) then
			return
		end

		--needs to be an attacking move
		if (context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical) then
			return
		end

		if (_ZONE.CurrentMap:GetCharAtLoc(context.ExplosionTile) ~= ownerChar) then
			return
		end

		--make sure incoming "attack" is from a foe
		if _DUNGEON:GetMatchup(ownerChar, context.User) ~= RogueEssence.Dungeon.Alignment.Foe then
			return
		end



		--print("Pass " .. ownerChar.Nickname)

		local teamcount = GAME:GetPlayerPartyCount()
		for i = 0, teamcount - 1, 1 do
			local partymember = GAME:GetPlayerPartyMember(i)
			--bodyguard must be next to you, holding a scarf, alive, and not yourself
			if partymember ~= ownerChar and not partymember.Dead and (partymember.CharLoc - ownerChar.CharLoc):Dist8() <= 1 and partymember.EquippedItem.ID == "held_synergy_scarf" then
				--print(partymember.MemberTeam:GetCharIndex(partymember).Char) -- print slot of teammate (also this is how you get the slot of a party member)

				--cannot bodyguard if sleeping, paralyzed, or frozen
				if partymember:GetStatusEffect("sleep") == nil and partymember:GetStatusEffect("paralyze") == nil and partymember:GetStatusEffect("freeze") == nil then

					local scarves_name = STRINGS:Format('\\uE0AE')..'[color=#FFCEFF]Synergy Scarves[color]'

					_DUNGEON:LogMsg(STRINGS:Format("{0}'s and {1}'s " .. scarves_name .. " glow brightly!", partymember:GetDisplayName(false), ownerChar:GetDisplayName(false)))

					local olddir = partymember.CharDir

					DUNGEON:CharTurnToChar(partymember, ownerChar)
					local anim = RogueEssence.Dungeon.CharAnimAction()

					anim.BaseFrameType = 40--Swing
					anim.AnimLoc = partymember.CharLoc
					anim.CharDir = partymember.CharDir
					TASK:WaitTask(partymember:StartAnim(anim))
					GAME:WaitFrames(16)
					--partymember.CharDir = olddir

					--_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_PASS_ATTACK"):ToLocal(), ownerChar:GetDisplayName(false), partymember:GetDisplayName(false)))
					_DUNGEON:LogMsg(STRINGS:Format("{0} intercepted the attack headed for {1}!", partymember:GetDisplayName(false), ownerChar:GetDisplayName(false)))
					context.ExplosionTile = partymember.CharLoc
					context.ContextStates:Set(PMDC.Dungeon.Redirected())
					return
				end
			end
		end
	end
end









-- Story rescue used by Chapter 6's Gloomy Forest.  This deliberately follows
-- the same BattleScriptEvent interaction path as ordinary rescue targets.
function BATTLE_SCRIPT.TeamDazzlingChenipentRescue(owner, ownerChar, context, args)
  if SV.Chapter6.ChenipentFound then
    context.CancelState.Cancel = true
    context.TurnCancel.Cancel = true
    return
  end

  context.CancelState.Cancel = true
  context.TurnCancel.Cancel = true
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6_001']))
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6_002']))
  SV.Chapter6.ChenipentFound = true
  UI:ResetSpeaker()
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6_003']))
end


-------------------------------------------------------------------------
-- Vague 9 : L'Annexe de la Toupie — les 5 habitants (structure Bazar Secret
-- de pret/pmd-sky : accueil / repos / echoppe / polissage / sortie).
-- Dialogues 100% New Era. Interactions via context (BattleScriptEvent).
-------------------------------------------------------------------------
function BATTLE_SCRIPT.AnnexePatron(owner, ownerChar, context, args)
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  local tbl = LTBL(context.Target)
  if tbl.Greeted == nil then
    tbl.Greeted = true
    UI:WaitShowDialogue("Ooooh ![pause=10] Des clients ![pause=20] Bienvenue, bienvenue à l'Annexe de la Toupie !")
    UI:WaitShowDialogue("Mon cousin tient le comptoir de Metano.[pause=10] Moi ?[pause=10] Je creuse des succursales là où les explorateurs en ont le plus besoin ![pause=20] C'est-à-dire... partout !")
    UI:WaitShowDialogue("Reprenez votre souffle.[pause=10] Ici, le donjon attend DEHORS.[pause=20] Règle de la maison !")
  else
    UI:WaitShowDialogue("Prenez votre temps ![pause=10] La Toupie tourne, mais elle n'est jamais pressée.")
  end
  context.Target.CharDir = oldDir
  context.CancelState.Cancel = true
end

function BATTLE_SCRIPT.AnnexeRepos(owner, ownerChar, context, args)
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  local tbl = LTBL(context.Target)
  if tbl.Rested ~= nil then
    UI:WaitShowDialogue("Mime... mime ![pause=10] (Elle mime un oreiller déjà utilisé.[pause=10] Une sieste par visite, semble-t-il.)")
  else
    UI:WaitShowDialogue("Mime mime ![pause=10] (Elle tapote un coussin invisible et vous invite à vous asseoir.)")
    UI:ChoiceMenuYesNo("Accepter la pause de Pausette ?", false)
    UI:WaitForChoice()
    if UI:ChoiceResult() then
      tbl.Rested = true
      SOUND:PlayBattleSE("DUN_Heal")
      for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
        local chara = GAME:GetPlayerPartyMember(i)
        chara:FullRestore()
      end
      UI:WaitShowDialogue("Mime ![pause=10] (Toute l'équipe se sent étonnamment reposée.[pause=20] Le donjon paraît moins hostile, vu d'ici.)")
    end
  end
  context.Target.CharDir = oldDir
  context.CancelState.Cancel = true
end

function BATTLE_SCRIPT.AnnexeEchoppe(owner, ownerChar, context, args)
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  local tbl = LTBL(context.Target)
  if tbl.Sold ~= nil then
    UI:WaitShowDialogue("Glou.[pause=10] Stock épuisé pour aujourd'hui.[pause=20] Un estomac n'est pas un entrepôt... quoique.")
  else
    UI:WaitShowDialogue("Bienvenue à l'échoppe de Gobble ![pause=10] Tout ce que je vends sort de mon estomac.[pause=20] Garanti sans acide.[pause=10] Ou presque.")
    UI:ChoiceMenuYesNo("Acheter une Pomme (100 Poke) ?", false)
    UI:WaitForChoice()
    if UI:ChoiceResult() then
      if GAME:GetPlayerMoney() >= 100 then
        GAME:RemoveFromPlayerMoney(100)
        GAME:GivePlayerItem("food_apple", 1, false, "")
        tbl.Sold = true
        SOUND:PlayBattleSE("DUN_Money")
        UI:WaitShowDialogue("Glou glou ![pause=10] Excellent choix.[pause=20] Elle n'a séjourné que deux jours dans mon jabot.")
      else
        UI:WaitShowDialogue("Glou...[pause=10] Pas assez de Poké.[pause=20] Je fais crédit à personne, même pas à moi.")
      end
    end
  end
  context.Target.CharDir = oldDir
  context.CancelState.Cancel = true
end

function BATTLE_SCRIPT.AnnexePolissage(owner, ownerChar, context, args)
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  local tbl = LTBL(context.Target)
  if tbl.Polished ~= nil then
    UI:WaitShowDialogue("Slurp...[pause=10] Ma langue a besoin de repos.[pause=20] Le polissage, c'est un art, pas une chaîne de montage.")
  else
    UI:WaitShowDialogue("Un objet terni ?[pause=10] Une baie douteuse ?[pause=20] Un coup de langue de Lustro, et ça repart comme neuf !")
    UI:ChoiceMenuYesNo("Confier votre équipement à la langue de Lustro ?", false)
    UI:WaitForChoice()
    if UI:ChoiceResult() then
      tbl.Polished = true
      SOUND:PlayBattleSE("DUN_Follow_Me")
      local finds = { "berry_oran", "berry_lum", "seed_reviver", "apricorn_plain" }
      -- Fix audit 2026-07-27 : RNG deterministe (GAME.Rand) au lieu de math.random.
      -- math.random n'est PAS enregistre par le systeme de replay/quicksave :
      -- au rechargement, l'objet donne differait -> desynchronisation d'inventaire
      -- -> cascade "Recorded action failed" puis crash ReplayData.ReadUI().
      local pick = finds[GAME.Rand:Next(0, #finds) + 1]
      GAME:GivePlayerItem(pick, 1, false, "")
      UI:WaitShowDialogue("Slurp ![pause=10] Slurp ![pause=20] Tenez :[pause=10] je l'ai trouvé dans la poussière du donjon.[pause=20] Maintenant, il BRILLE.[pause=10] Ne demandez pas comment ça marche.")
    end
  end
  context.Target.CharDir = oldDir
  context.CancelState.Cancel = true
end

function BATTLE_SCRIPT.AnnexeSortie(owner, ownerChar, context, args)
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  UI:WaitShowDialogue("...Je connais tous les murs de ce monde.[pause=20] Aucun ne me retient.")
  UI:ChoiceMenuYesNo("Demander à Passe-Mue de vous faire sortir du donjon ?", false)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    UI:WaitShowDialogue("...Fermez les yeux.[pause=30] Les murs n'existent que si on les regarde.")
    GAME:WaitFrames(30)
    TASK:WaitTask(_DUNGEON:EndSegment(RogueEssence.Data.GameProgress.ResultType.Escaped))
  end
  context.Target.CharDir = oldDir
  context.CancelState.Cancel = true
end

