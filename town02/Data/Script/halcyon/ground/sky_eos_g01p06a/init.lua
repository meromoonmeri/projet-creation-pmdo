require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_g01p06a={}
function sky_eos_g01p06a.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_g01p06a.Enter(map) GAME:FadeIn(20) end
function sky_eos_g01p06a.Exit(map) end
function sky_eos_g01p06a.Update(map,time) end
function sky_eos_g01p06a.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_g01p06a.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_g01p06a
