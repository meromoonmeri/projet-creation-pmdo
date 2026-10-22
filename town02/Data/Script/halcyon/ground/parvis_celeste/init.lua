--[[ Parvis Céleste — entrée de la Tour Céleste (Sky Tower) d'origine PMD Red.
     Entièrement connecté au donjon canonique sky_tower de New Era.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
require 'halcyon.ChapterScenes'

local parvis_celeste = {}

function parvis_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_parvis_celeste")
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function parvis_celeste.Enter(map)
  GAME:FadeIn(20)
end

function parvis_celeste.Update(map, time)
end

function parvis_celeste.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("Entrer dans la Tour Céleste ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    partner.IsInteracting = false
    pcall(function() GROUND:CharEndAnim(partner) end)
    pcall(function() GROUND:CharEndAnim(CH('PLAYER')) end)
    pcall(function() ChapterScenes.PeakTowerReveal() end)
    partner.IsInteracting = true
    pcall(function() GROUND:CharSetAnim(partner, 'None', true) end)
    pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'None', true) end)

    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("sky_tower", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  else
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
  end
end

function parvis_celeste.Kangaskhan_Rock_Action(obj, activator)
  local chara = CH('PLAYER')
  local partner = CH('Teammate1')
  GROUND:CharTurnToChar(chara, partner)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Sauvegarder la partie ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:SaveDungeonDay()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("La partie a été sauvegardée.")
    UI:SetCenter(false)
  end
end

return parvis_celeste
