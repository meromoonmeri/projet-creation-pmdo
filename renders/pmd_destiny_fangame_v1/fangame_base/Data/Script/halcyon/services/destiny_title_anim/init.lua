--[[
  destiny_title_anim/init.lua
  Service persistant pour Pokemon Mystery Dungeon : Destiny (PMDO 0.8.12).

  Anime en boucle temps reel les 24 poses de Content/BG/Title_Screen_Background.dir
  (Crepuscule Dore -> Heure Bleue -> Soir & Nuit Etoilee Scintillante -> Retour)
  sous TopMenu et tous ses sous-menus via LowerSummaryMenus + MenuDirTex(TexType.BG).
]]--
require 'origin.common'
require 'origin.services.baseservice'

local DestinyTitleAnim = Class('DestinyTitleAnim', BaseService)

function DestinyTitleAnim:initialize()
  BaseService.initialize(self)
  if PrintInfo then
    PrintInfo('[PMD:Destiny] Service destiny_title_anim initialise (24p x 12t).')
  end
end

function DestinyTitleAnim:OnAddMenu(menu)
  if menu == nil then
    return
  end
  pcall(function()
    if menu.Label == RogueEssence.Menu.MenuLabel.TOP_MENU then
      -- Cadre hors-ecran (-16,-16,352,272) masquant la bordure MenuBG tout en dessinant (16,16)->(0,0) !
      local bg_summary = RogueEssence.Menu.SummaryMenu(
        "DESTINY_TITLE_BG_SUMMARY",
        RogueElements.Rect(-16, -16, 352, 272)
      )
      local anim = RogueEssence.Content.AnimData("Title_Screen_Background", 12)
      local dir_tex = RogueEssence.Menu.MenuDirTex(
        "DESTINY_TITLE_BG_TEX",
        RogueElements.Loc(16, 16),
        RogueEssence.Menu.MenuDirTex.TexType.BG,
        anim
      )
      bg_summary.Elements:Add(dir_tex)
      menu.LowerSummaryMenus:Insert(0, bg_summary)
    end
  end)
end

function DestinyTitleAnim:Subscribe(med)
  med:Subscribe("DestinyTitleAnim", EngineServiceEvents.AddMenu, function(_, args)
    if args ~= nil then
      self:OnAddMenu(args[0])
    end
  end)
end

function DestinyTitleAnim:UnSubscribe(med)
end

SCRIPT:AddService("DestinyTitleAnim", DestinyTitleAnim:new())
return DestinyTitleAnim
