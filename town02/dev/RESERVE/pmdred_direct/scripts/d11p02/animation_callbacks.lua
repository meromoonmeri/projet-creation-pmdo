-- Generated integration adapter; merge these callbacks, do not replace scene logic.
local DirectAnimation = require 'halcyon.RedDirectGroundAnimation'
local Metadata = require 'halcyon.ground.d11p02.animation_metadata'
local Adapter = {}

function Adapter.Init(map)
  DirectAnimation.Start(map, Metadata)
end

function Adapter.Update(map)
  DirectAnimation.Update(map)
end

function Adapter.Exit(map)
  DirectAnimation.Finish(map)
end

function Adapter.Cancel(map)
  DirectAnimation.Cancel(map)
end

return Adapter
