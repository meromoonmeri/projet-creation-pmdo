local mod = require 'halcyon.LulubyTown'
local luluby_town_morning = {}
function luluby_town_morning.Init(map) mod.Init(map) end
function luluby_town_morning.Enter(map) mod.Enter(map) end
function luluby_town_morning.Update(map, time) if mod.Update then mod.Update(map, time) end end
function luluby_town_morning.GameSave(map) if mod.GameSave then mod.GameSave(map) end end
function luluby_town_morning.GameLoad(map) if mod.GameLoad then mod.GameLoad(map) end end
return luluby_town_morning
