require 'origin.common'
local grotte_ouest_sanctuaire_mewtwo = {}
function grotte_ouest_sanctuaire_mewtwo.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function grotte_ouest_sanctuaire_mewtwo.Enter(map) GAME:FadeIn(20) end
function grotte_ouest_sanctuaire_mewtwo.Exit(map) end
function grotte_ouest_sanctuaire_mewtwo.Update(map) end
function grotte_ouest_sanctuaire_mewtwo.GameSave(map) end
function grotte_ouest_sanctuaire_mewtwo.GameLoad(map) GAME:FadeIn(20) end
return grotte_ouest_sanctuaire_mewtwo
