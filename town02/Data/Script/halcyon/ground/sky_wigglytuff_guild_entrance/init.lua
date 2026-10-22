require 'origin.common'
require 'halcyon.PartnerEssentials'
local sky_wigglytuff_guild_entrance={}
function sky_wigglytuff_guild_entrance.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_wigglytuff_guild_entrance.Enter(map) GAME:FadeIn(20) end
function sky_wigglytuff_guild_entrance.GuildExterior_Exit_Touch(obj,activator) GAME:EnterGroundMap('guilde_parvis','GuildEntranceMarker') end
function sky_wigglytuff_guild_entrance.MainHall_Entrance_Touch(obj,activator) GAME:EnterGroundMap('sky_wigglytuff_guild_main','Main_Entrance_Marker') end
function sky_wigglytuff_guild_entrance.Exit(map) end function sky_wigglytuff_guild_entrance.Update(map,time) end
function sky_wigglytuff_guild_entrance.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_wigglytuff_guild_entrance.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_wigglytuff_guild_entrance
