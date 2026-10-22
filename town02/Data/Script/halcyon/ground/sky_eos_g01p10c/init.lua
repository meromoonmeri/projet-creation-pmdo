require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p10c={}
function sky_eos_g01p10c.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p10c.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p10c.Exit(map) end
function sky_eos_g01p10c.Update(map,time) end
function sky_eos_g01p10c.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p10c.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p10c
