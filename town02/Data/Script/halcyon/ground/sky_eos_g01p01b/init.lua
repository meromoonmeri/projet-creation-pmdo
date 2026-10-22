require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p01b={}
function sky_eos_g01p01b.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p01b.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p01b.Exit(map) end
function sky_eos_g01p01b.Update(map,time) end
function sky_eos_g01p01b.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p01b.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p01b
