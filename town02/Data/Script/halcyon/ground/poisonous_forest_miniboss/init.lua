--[[
    init.lua
    Forgotten Marsh — salle cinématique du mini-boss (Chapitre 9)
    Boue et venin : Avaltout + Coatox.
    Patron : searing_tunnel_miniboss (dispatch Seen/Defeated/Lost),
    simplifié : flash blanc + dialogues (directive utilisateur).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.poisonous_forest_miniboss.forgotten_marsh_miniboss_ch_9'

local poisonous_forest_miniboss = {}

function poisonous_forest_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_poisonous_forest_miniboss")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function poisonous_forest_miniboss.Enter(map)
  if SV.Chapter9.MarshMiniBossSeen == nil then SV.Chapter9.MarshMiniBossSeen = false end
  if SV.Chapter9.MarshMiniBossDefeated == nil then SV.Chapter9.MarshMiniBossDefeated = false end
  if SV.Chapter9.MarshMiniBossLost == nil then SV.Chapter9.MarshMiniBossLost = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_poisonous_forest_miniboss")

  if SV.Chapter9.MarshMiniBossDefeated then
    SV.Chapter9.MarshMiniBossDefeated = false
    poisonous_forest_miniboss_ch_9.DefeatedBoss()
  elseif SV.Chapter9.MarshMiniBossLost then
    SV.Chapter9.MarshMiniBossLost = false
    poisonous_forest_miniboss_ch_9.DiedToBoss()
  elseif SV.Chapter9.MarshMiniBossSeen then
    poisonous_forest_miniboss_ch_9.SecondPreBossScene()
  else
    poisonous_forest_miniboss_ch_9.FirstPreBossScene()
  end
end

function poisonous_forest_miniboss.Update(map, time)
end

function poisonous_forest_miniboss.GameSave(map)
end

function poisonous_forest_miniboss.GameLoad(map)
end

return poisonous_forest_miniboss
