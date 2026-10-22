require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_t00p01={}
function sky_eos_t00p01.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_t00p01.Enter(map) GAME:FadeIn(20) end
function sky_eos_t00p01.Exit(map) end
function sky_eos_t00p01.Update(map,time) end
function sky_eos_t00p01.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_t00p01.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_t00p01
