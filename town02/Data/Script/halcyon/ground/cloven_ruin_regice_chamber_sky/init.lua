local mod = require 'halcyon.ClovenCanonicalChamber'
local cloven_ruin_regice_chamber_sky = {}
function cloven_ruin_regice_chamber_sky.Init(map) mod.Init(map) end
function cloven_ruin_regice_chamber_sky.Enter(map) mod.Enter(map) end
function cloven_ruin_regice_chamber_sky.Update(map, time) if mod.Update then mod.Update(map, time) end end
function cloven_ruin_regice_chamber_sky.GameSave(map) if mod.GameSave then mod.GameSave(map) end end
function cloven_ruin_regice_chamber_sky.GameLoad(map) if mod.GameLoad then mod.GameLoad(map) end end
return cloven_ruin_regice_chamber_sky
