require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_t00p02={}
function sky_eos_t00p02.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_t00p02.Enter(map) GAME:FadeIn(20) end
function sky_eos_t00p02.Exit(map) end
function sky_eos_t00p02.Update(map,time) end
function sky_eos_t00p02.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_t00p02.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_t00p02
