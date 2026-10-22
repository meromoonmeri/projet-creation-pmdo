local mod = require 'halcyon.LulubyTown'
local luluby_town_evening = {}
function luluby_town_evening.Init(map) mod.Init(map) end
function luluby_town_evening.Enter(map) mod.Enter(map) end
function luluby_town_evening.Update(map, time) if mod.Update then mod.Update(map, time) end end
function luluby_town_evening.GameSave(map) if mod.GameSave then mod.GameSave(map) end end
function luluby_town_evening.GameLoad(map) if mod.GameLoad then mod.GameLoad(map) end end
return luluby_town_evening
