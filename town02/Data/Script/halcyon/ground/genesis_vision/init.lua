--[[
    init.lua
    Genesis Vision — cinematique de la Genese
    Carte purement narrative (pas de gameplay).
]]
require 'origin.common'
require 'halcyon.ground.genesis_vision.genesis_vision_ch_7'

local genesis_vision = {}

function genesis_vision.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_genesis_vision <<=')
end

function genesis_vision.Enter(map)
  genesis_vision_ch_7.PlayGenesis()
end

function genesis_vision.Update(map)
end

function genesis_vision.GameSave(map)
end

function genesis_vision.GameLoad(map)
end

return genesis_vision
