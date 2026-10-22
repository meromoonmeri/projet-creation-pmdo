require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_p01p02a={}
function sky_eos_p01p02a.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_p01p02a.Enter(map) GAME:FadeIn(20) end
function sky_eos_p01p02a.Exit(map) end
function sky_eos_p01p02a.Update(map,time) end
function sky_eos_p01p02a.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_p01p02a.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_p01p02a
