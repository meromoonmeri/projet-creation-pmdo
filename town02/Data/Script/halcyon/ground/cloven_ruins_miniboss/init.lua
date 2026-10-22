--[[
    init.lua
    Aegis Cave — salle cinématique des gardiens (Chapitre 5)
    Gardiens antiques : Kaorine + Golemastoc.
    Patron : searing_tunnel_miniboss (dispatch Seen/Defeated/Lost),
    simplifié : flash blanc + dialogues (directive utilisateur).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.cloven_ruins_miniboss.cloven_ruins_miniboss_ch_5'

local cloven_ruins_miniboss = {}

function cloven_ruins_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins_miniboss")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_miniboss.Enter(map)
  if SV.Chapter5.RuinsMiniBossSeen == nil then SV.Chapter5.RuinsMiniBossSeen = false end
  if SV.Chapter5.RuinsMiniBossDefeated == nil then SV.Chapter5.RuinsMiniBossDefeated = false end
  if SV.Chapter5.RuinsMiniBossLost == nil then SV.Chapter5.RuinsMiniBossLost = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_cloven_ruins_miniboss")

  if SV.Chapter5.RuinsMiniBossDefeated then
    SV.Chapter5.RuinsMiniBossDefeated = false
    cloven_ruins_miniboss_ch_5.DefeatedBoss()
  elseif SV.Chapter5.RuinsMiniBossLost then
    SV.Chapter5.RuinsMiniBossLost = false
    cloven_ruins_miniboss_ch_5.DiedToBoss()
  elseif SV.Chapter5.RuinsMiniBossSeen then
    cloven_ruins_miniboss_ch_5.SecondPreBossScene()
  else
    cloven_ruins_miniboss_ch_5.FirstPreBossScene()
  end
end

function cloven_ruins_miniboss.Update(map, time)
end

function cloven_ruins_miniboss.GameSave(map)
end

function cloven_ruins_miniboss.GameLoad(map)
end

return cloven_ruins_miniboss
