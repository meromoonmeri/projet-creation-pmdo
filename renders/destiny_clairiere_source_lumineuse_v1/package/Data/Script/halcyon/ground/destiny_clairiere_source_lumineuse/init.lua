require 'origin.common'
local destiny_clairiere_source_lumineuse = {}
function destiny_clairiere_source_lumineuse.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function destiny_clairiere_source_lumineuse.Enter(map) GAME:FadeIn(20) end
function destiny_clairiere_source_lumineuse.Exit(map) end
function destiny_clairiere_source_lumineuse.Update(map) end
function destiny_clairiere_source_lumineuse.GameSave(map) end
function destiny_clairiere_source_lumineuse.GameLoad(map) GAME:FadeIn(20) end
return destiny_clairiere_source_lumineuse
