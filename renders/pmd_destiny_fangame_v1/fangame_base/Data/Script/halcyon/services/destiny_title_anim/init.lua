--[[
  destiny_title_anim/init.lua
  Service persistant pour Pokemon Mystery Dungeon : Destiny (PMDO 0.8.12).

  Fonctionnalites :
  1) Fonds separes JOUR (`Title_Screen_Background_Jour.dir`) et NUIT (`Title_Screen_Background_Nuit.dir`)
     avec selection automatique selon l'heure locale (06h-19h = Jour, 19h-06h = Nuit) ou forcage manuel
     via `DestinyTitleAnim.ForceMode = 'jour' | 'nuit'`.
  2) Animation en direct des 24 poses sous `TopMenu` via `LowerSummaryMenus` + `MenuDirTex(TexType.BG)`.
  3) Helper `DestinyTitleAnim.PlayAnimeOpening(mode)` pour jouer en scene d'ouverture l'apparition
     unique du blason Oeuf Aile (`Destiny_Logo_Anime_Opening`) sur le fond Jour ou Nuit.
]]--
require 'origin.common'
require 'origin.services.baseservice'

local DestinyTitleAnim = Class('DestinyTitleAnim', BaseService)
DestinyTitleAnim.ForceMode = nil -- nil = auto Jour/Nuit selon l'heure locale, ou 'jour' / 'nuit'

function DestinyTitleAnim:GetActiveBGName()
  if self.ForceMode == 'jour' then
    return 'Title_Screen_Background_Jour'
  elseif self.ForceMode == 'nuit' then
    return 'Title_Screen_Background_Nuit'
  end
  local ok, hr = pcall(function() return tonumber(os.date('%H')) end)
  if ok and hr ~= nil and (hr < 6 or hr >= 19) then
    return 'Title_Screen_Background_Nuit'
  end
  return 'Title_Screen_Background_Jour'
end

function DestinyTitleAnim:initialize()
  BaseService.initialize(self)
  if PrintInfo then
    PrintInfo('[PMD:Destiny] Service destiny_title_anim (Jour & Nuit separes + Opening) initialise.')
  end
end

function DestinyTitleAnim:OnAddMenu(menu)
  if menu == nil then
    return
  end
  pcall(function()
    if menu.Label == RogueEssence.Menu.MenuLabel.TOP_MENU then
      local bg_name = self:GetActiveBGName()
      local bg_summary = RogueEssence.Menu.SummaryMenu(
        "DESTINY_TITLE_BG_SUMMARY",
        RogueElements.Rect(-16, -16, 352, 272)
      )
      local anim = RogueEssence.Content.AnimData(bg_name, 10)
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

local instance = DestinyTitleAnim:new()
SCRIPT:AddService("DestinyTitleAnim", instance)
return instance
