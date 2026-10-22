--[[
    Config Tools

    This service deals with config related stuff.
]]--
require 'origin.common'
require 'origin.services.baseservice'

--Declare class ConfigTools
local ConfigTools = Class('ConfigTools', BaseService)

--[[---------------------------------------------------------------
    ConfigTools:initialize()
      ConfigTools class constructor
---------------------------------------------------------------]]
function ConfigTools:initialize()
    BaseService.initialize(self)
    PrintInfo('ConfigTools:initialize()')
end

--[[---------------------------------------------------------------
    ConfigTools:__gc()
      ConfigTools class gc method
      Essentially called when the garbage collector collects the service.
  ---------------------------------------------------------------]]
--function ConfigTools:__gc()
--  PrintInfo('*****************ConfigTools:__gc()')
--end

--[[---------------------------------------------------------------
    ConfigTools:OnInit()
      Called on initialization of the script engine by the game!
---------------------------------------------------------------]]
function ConfigTools:OnInit()
    assert(self, 'ConfigTools:OnInit() : self is null!')
    PrintInfo("\n<!> ConfigTools: Init..")
end

--[[---------------------------------------------------------------
    ConfigTools:OnDeinit()
      Called on de-initialization of the script engine by the game!
---------------------------------------------------------------]]
function ConfigTools:OnDeinit()
    assert(self, 'ConfigTools:OnDeinit() : self is null!')
    PrintInfo("\n<!> ConfigTools: Deinit..")
end

function ConfigTools:OnSaveLoad()
    if CONFIG.Nicknames ~= nil or CONFIG.Starters ~= nil then
        self:StoreConfig()
    end
end

function ConfigTools:LoadConfig()
    CONFIG.Nicknames = CONFIG.UseNicknames()
    CONFIG.Starters  = CONFIG.RegularStarters()
end

function ConfigTools:StoreConfig()
    SV.Settings = SV.Settings or {}
    SV.Settings.Nicknames = 1
    if CONFIG.Nicknames then SV.Settings.Nicknames = 0 end
    SV.Settings.Starters = 1
    if CONFIG.Starters then SV.Settings.Starters = 0 end
    CONFIG.Nicknames = nil
    CONFIG.Starters = nil
end

function ConfigTools:OnAddMenu(menu)
    -- only add page if the save data has not been loaded yet
    if menu:HasLabel() and menu.Label == "SETTINGS_MENU" and not menu.InGame then
        self:LoadConfig()
        local page = menu:AddPage("halcyon", "New Era : Abyss to Ascension Settings")
        local options1 = {"Regular", "All"}
        local options2 = {"Yes", "No"}
        local save1 = function(setting) SV.Settings.Starters = setting.CurrentChoice end
        local save2 = function(setting) SV.Settings.Nicknames = setting.CurrentChoice end
        page.GlobalSaveAction = function() self.LoadConfig() end

        page:AddSetting("Starters", options1, SV.Settings.Starters, save1)
        page:AddSetting("Nicknames", options2, SV.Settings.Nicknames, save2)
    end
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function ConfigTools:Subscribe(med)
    med:Subscribe("ConfigTools", EngineServiceEvents.Init,               function() self.OnInit(self) end )
    med:Subscribe("ConfigTools", EngineServiceEvents.Deinit,             function() self.OnDeinit(self) end )
    med:Subscribe("ConfigTools", EngineServiceEvents.LoadSavedData,      function() self.OnSaveLoad(self) end )
    med:Subscribe("ConfigTools", EngineServiceEvents.AddMenu,            function(_, args) self.OnAddMenu(self, args[0]) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function ConfigTools:UnSubscribe(med)
end

---Summary
-- The update method is run as a coroutine for each services.
function ConfigTools:Update(gtime)
    --  while(true)
    --    coroutine.yield()
    --  end
end

--Add our service
SCRIPT:AddService("ConfigTools", ConfigTools:new())
return ConfigTools