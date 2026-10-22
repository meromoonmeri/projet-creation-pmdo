require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p01c={}
function sky_eos_g01p01c.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p01c.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p01c.Exit(map) end
function sky_eos_g01p01c.Update(map,time) end
function sky_eos_g01p01c.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p01c.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p01c
