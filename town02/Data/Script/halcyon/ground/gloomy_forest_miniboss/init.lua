--[[
    init.lua
    Gloomy Forest — salle cinématique du mini-boss (Chapitre 6)
    Gardiens du cœur : Tengalice + Cornèbre.
    Patron : searing_tunnel_miniboss (dispatch Seen/Defeated/Lost),
    simplifié : flash blanc + dialogues (directive utilisateur).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.gloomy_forest_miniboss.gloomy_forest_miniboss_ch_6'

local gloomy_forest_miniboss = {}

function gloomy_forest_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gloomy_forest_miniboss")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_miniboss.Enter(map)
  if SV.Chapter6.GloomyMiniBossSeen == nil then SV.Chapter6.GloomyMiniBossSeen = false end
  if SV.Chapter6.GloomyMiniBossDefeated == nil then SV.Chapter6.GloomyMiniBossDefeated = false end
  if SV.Chapter6.GloomyMiniBossLost == nil then SV.Chapter6.GloomyMiniBossLost = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_gloomy_forest_miniboss")

  if SV.Chapter6.GloomyMiniBossDefeated then
    SV.Chapter6.GloomyMiniBossDefeated = false
    gloomy_forest_miniboss_ch_6.DefeatedBoss()
  elseif SV.Chapter6.GloomyMiniBossLost then
    SV.Chapter6.GloomyMiniBossLost = false
    gloomy_forest_miniboss_ch_6.DiedToBoss()
  elseif SV.Chapter6.GloomyMiniBossSeen then
    gloomy_forest_miniboss_ch_6.SecondPreBossScene()
  else
    gloomy_forest_miniboss_ch_6.FirstPreBossScene()
  end
end

function gloomy_forest_miniboss.Update(map, time)
end

function gloomy_forest_miniboss.GameSave(map)
end

function gloomy_forest_miniboss.GameLoad(map)
end

return gloomy_forest_miniboss
