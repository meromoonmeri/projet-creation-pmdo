require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p06b={}
function sky_eos_g01p06b.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p06b.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p06b.Exit(map) end
function sky_eos_g01p06b.Update(map,time) end
function sky_eos_g01p06b.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p06b.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p06b
