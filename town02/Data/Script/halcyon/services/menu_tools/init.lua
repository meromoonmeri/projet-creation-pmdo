--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'origin.common'
require 'origin.services.baseservice'
require 'origin.recruit_list'

--Declare class MenuTools
local MenuTools = Class('MenuTools', BaseService)


--[[---------------------------------------------------------------
    MenuTools:initialize()
      MenuTools class constructor
---------------------------------------------------------------]]
function MenuTools:initialize()
  BaseService.initialize(self)
  PrintInfo('MenuTools:initialize()')
end

--[[---------------------------------------------------------------
    MenuTools:__gc()
      MenuTools class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function MenuTools:__gc()
--  PrintInfo('*****************MenuTools:__gc()')
--end



--[[---------------------------------------------------------------
    MenuTools:OnMenuButtonPressed()
      When the main menu button is pressed or the main menu should be enabled this is called!
      This is called as a coroutine.
---------------------------------------------------------------]]
function MenuTools:OnMenuButtonPressed()
  if MenuTools.MainMenu == nil then
    MenuTools.MainMenu = RogueEssence.Menu.MainMenu()
  end
  
  MenuTools.MainMenu:SetupChoices()
  
  --Halcyon custom menu stuff for jobs. 
  --Check if we're in a dungeon or not. Only do main menu changes outside of a dungeon. Do others menu changes in dungeon only.
  if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
    MenuTools.MainMenu.Choices:RemoveAt(5)
    MenuTools.MainMenu.Choices:Insert(5, RogueEssence.Menu.MenuTextChoice("Others", function () _MENU:AddMenu(MenuTools:CustomDungeonOthersMenu(), false) end))
  else--not in a dungeon 
	--Add Job List option
	local taken_count = MISSION_GEN.GetTakenCount()
	local job_list_color = Color.Red
	if taken_count > 0 then
		job_list_color = Color.White
	end 
	
	MenuTools.MainMenu.Choices:Insert(4, RogueEssence.Menu.MenuTextChoice("Job List", function () _MENU:AddMenu(BoardMenu:new(COMMON.MISSION_BOARD_TAKEN, nil, MenuTools.MainMenu).menu, false) end, taken_count > 0, job_list_color))
 
	--Add rank/points to go 
	--local level_length = RogueEssence.Content.GraphicsManager.TextFont.SubstringWidth(STRINGS:FormatKey("MENU_TEAM_LEVEL_SHORT") .. tostring(RogueEssence.Data.DataManager.Instance.Start.MaxLevel))
	--local hp_length = RogueEssence.Content.GraphicsManager.TextFont.SubstringWidth(STRINGS:FormatKey("MENU_TEAM_HP") .. " {999}/{999}")
	--local hunger_length = RogueEssence.Content.GraphicsManager.TextFont.SubstringWidth(STRINGS:FormatKey("MENU_TEAM_HUNGER") .. " {Character.MAX_FULLNESS}/{Character.MAX_FULLNESS}");

	--local rankStart = RogueEssence.Content.GraphicsManager.MenuBG.TileWidth + 4 + MenuTools.NicknameMenu.MAX_LENGTH + level_length + hp_length + remaining_width				
	--local remaining_width = MenuTools.MainMenu.SummaryMenuBounds.End.X - MenuTools.MainMenu.SummaryMenuBounds.X - (RogueEssence.Content.GraphicsManager.MenuBG.TileWidth + 4) * 2 - level_length - hp_length - hunger_length - MenuTools.NicknameMenu.MAX_LENGTH


  end
 
  MenuTools.MainMenu:SetupTitleAndSummary()
  
  --need to do this after setting up title and summary
  --Add rank/points to go in overworld
  if RogueEssence.GameManager.Instance.CurrentScene ~= RogueEssence.Dungeon.DungeonScene.Instance then
  	local rank = _DATA.Save.ActiveTeam.Rank
	local to_go = _DATA:GetRank(rank).FameToNext - _DATA.Save.ActiveTeam.Fame 
	rank = "[color=#FFA5FF]" .. rank:gsub("^%l", string.upper) .. "[color]"
	
	-- -1 to go represents max rank
	if to_go < 0 then
		to_go = "Maxed!"
	end
	
	to_go = "[color=#00FFFF]" .. to_go .. "[color]"
  
    MenuTools.MainMenu.SummaryElements:Add(RogueEssence.Menu.MenuText("Rank: " .. rank,
											RogueElements.Loc(104, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight), RogueElements.DirH.Left))
	
  	MenuTools.MainMenu.SummaryElements:Add(RogueEssence.Menu.MenuText("To go: " .. to_go,
                    RogueElements.Loc(206, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight), RogueElements.DirH.Left))
  end
  
  MenuTools.MainMenu:InitMenu()
  TASK:WaitTask(_MENU:ProcessMenuCoroutine(MenuTools.MainMenu))
end



function MenuTools:CustomDungeonOthersMenu()
    local menu = RogueEssence.Menu.OthersMenu()
    menu:SetupChoices();
	if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
		menu.Choices:Add(RogueEssence.Menu.MenuTextChoice("Mission Objectives", function () _MENU:AddMenu(DungeonJobList:new().menu, false) end))
		-- add recruitment search menu only if assembly is unlocked
		if SV.Chapter4 and SV.Chapter4.FinishedAssemblyIntro then
			menu.Choices:Add(RogueEssence.Menu.MenuTextChoice(RogueEssence.StringKey("MENU_RECRUITMENT"):ToLocal(), function () _MENU:AddMenu(RecruitmentListMenu:new().menu, false) end))
		end
	end
	menu:InitMenu();
    return menu
end


---Summary
-- Subscribe to all channels this service wants callbacks from
function MenuTools:Subscribe(med)
  med:Subscribe("MenuTools", EngineServiceEvents.MenuButtonPressed,        function() self.OnMenuButtonPressed() end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function MenuTools:UnSubscribe(med)
end


--Add our service
SCRIPT:AddService("MenuTools", MenuTools:new())
return MenuTools