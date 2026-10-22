local mod = require 'halcyon.LulubyTown'
local luluby_town_night = {}
function luluby_town_night.Init(map) mod.Init(map) end
function luluby_town_night.Enter(map) mod.Enter(map) end
function luluby_town_night.Update(map, time) if mod.Update then mod.Update(map, time) end end
function luluby_town_night.GameSave(map) if mod.GameSave then mod.GameSave(map) end end
function luluby_town_night.GameLoad(map) if mod.GameLoad then mod.GameLoad(map) end end
return luluby_town_night
