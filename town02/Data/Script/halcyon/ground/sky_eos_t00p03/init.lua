require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_eos_t00p03={}
function sky_eos_t00p03.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_eos_t00p03.Enter(map) GAME:FadeIn(20) end
function sky_eos_t00p03.Exit(map) end
function sky_eos_t00p03.Update(map,time) end
function sky_eos_t00p03.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_eos_t00p03.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_eos_t00p03
