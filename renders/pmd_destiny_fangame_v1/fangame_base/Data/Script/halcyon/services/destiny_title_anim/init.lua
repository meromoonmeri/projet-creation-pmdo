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
DestinyTitleAnim.PlayedOpening = false   -- l'Opening d'Anime n'est joue qu'une fois par session de jeu
DestinyTitleAnim.OpeningSummary = nil    -- calque plein ecran de l'Opening en cours
DestinyTitleAnim.TopMenu = nil           -- reference au menu-titre pour retirer le calque
DestinyTitleAnim.OpeningStart = nil      -- horodatage (ms) du debut de l'Opening
DestinyTitleAnim.OPENING_MS = 8600       -- 24 poses x 10 ticks (~8 s) + marge de fondu

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
      self.TopMenu = menu
      -- Lancement du jeu : l'Opening d'Anime passe UNE fois, plein ecran, avant le titre
      if not self.PlayedOpening then
        self.PlayedOpening = true
        self:PlayAnimeOpening(bg_name)
      end
    end
  end)
end

--[[---------------------------------------------------------------
    DestinyTitleAnim:PlayAnimeOpening(bg_name)
    Joue la sequence d'Opening d'Anime (`Destiny_Logo_Anime_Opening`,
    24 poses, une seule fois) en calque plein ecran PAR-DESSUS le fond
    Jour/Nuit du menu-titre ; OnUpdate retire le calque a la fin.
---------------------------------------------------------------]]
function DestinyTitleAnim:PlayAnimeOpening(bg_name)
  local menu = self.TopMenu
  if menu == nil then
    return false
  end
  return pcall(function()
    local ov = RogueEssence.Menu.SummaryMenu(
      "DESTINY_OPENING_OVERLAY",
      RogueElements.Rect(-16, -16, 352, 272)
    )
    local bg_anim = RogueEssence.Content.AnimData(bg_name or self:GetActiveBGName(), 10)
    ov.Elements:Add(RogueEssence.Menu.MenuDirTex(
      "DESTINY_OPENING_BG_TEX",
      RogueElements.Loc(16, 16),
      RogueEssence.Menu.MenuDirTex.TexType.BG,
      bg_anim
    ))
    local open_anim = RogueEssence.Content.AnimData("Destiny_Logo_Anime_Opening", 10)
    ov.Elements:Add(RogueEssence.Menu.MenuDirTex(
      "DESTINY_OPENING_ANIM_TEX",
      RogueElements.Loc(16, 16),
      RogueEssence.Menu.MenuDirTex.TexType.OBJ,
      open_anim
    ))
    menu.LowerSummaryMenus:Insert(0, ov)
    self.OpeningSummary = ov
    self.OpeningStart = nil
  end)
end

--[[---------------------------------------------------------------
    DestinyTitleAnim:OnUpdate(curtime)
    Retire le calque d'Opening une fois la sequence terminee : le
    menu-titre Jour/Nuit reaparait dessous.
---------------------------------------------------------------]]
function DestinyTitleAnim:OnUpdate(curtime)
  if self.OpeningSummary == nil then
    return
  end
  if self.OpeningStart == nil then
    self.OpeningStart = curtime
    return
  end
  if (curtime - self.OpeningStart) >= self.OPENING_MS then
    local ov, menu = self.OpeningSummary, self.TopMenu
    self.OpeningSummary, self.OpeningStart = nil, nil
    pcall(function()
      if menu ~= nil and ov ~= nil then
        menu.LowerSummaryMenus:Remove(ov)
      end
    end)
  end
end

function DestinyTitleAnim:Subscribe(med)
  med:Subscribe("DestinyTitleAnim", EngineServiceEvents.AddMenu, function(_, args)
    if args ~= nil then
      self:OnAddMenu(args[0])
    end
  end)
  med:Subscribe("DestinyTitleAnim", EngineServiceEvents.Update, function(curtime)
    self:OnUpdate(curtime)
  end)
end

function DestinyTitleAnim:UnSubscribe(med)
end

local instance = DestinyTitleAnim:new()
SCRIPT:AddService("DestinyTitleAnim", instance)
return instance
