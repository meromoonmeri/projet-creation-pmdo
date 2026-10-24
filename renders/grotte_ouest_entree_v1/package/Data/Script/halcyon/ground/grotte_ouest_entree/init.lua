require 'origin.common'
local grotte_ouest_entree = {}
function grotte_ouest_entree.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function grotte_ouest_entree.Enter(map) GAME:FadeIn(20) end
function grotte_ouest_entree.Exit(map) end
function grotte_ouest_entree.Update(map) end
function grotte_ouest_entree.GameSave(map) end
function grotte_ouest_entree.GameLoad(map) GAME:FadeIn(20) end
return grotte_ouest_entree
