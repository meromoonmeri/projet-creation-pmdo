require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p09a={}
function sky_eos_g01p09a.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p09a.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p09a.Exit(map) end
function sky_eos_g01p09a.Update(map,time) end
function sky_eos_g01p09a.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p09a.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p09a
