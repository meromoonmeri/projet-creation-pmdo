require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p05c={}
function sky_eos_g01p05c.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p05c.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p05c.Exit(map) end
function sky_eos_g01p05c.Update(map,time) end
function sky_eos_g01p05c.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p05c.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p05c
