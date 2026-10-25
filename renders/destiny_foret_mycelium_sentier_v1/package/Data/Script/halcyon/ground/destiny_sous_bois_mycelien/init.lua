require 'origin.common'
local destiny_sous_bois_mycelien = {}
function destiny_sous_bois_mycelien.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function destiny_sous_bois_mycelien.Enter(map) GAME:FadeIn(20) end
function destiny_sous_bois_mycelien.Exit(map) end
function destiny_sous_bois_mycelien.Update(map) end
function destiny_sous_bois_mycelien.GameSave(map) end
function destiny_sous_bois_mycelien.GameLoad(map) GAME:FadeIn(20) end
return destiny_sous_bois_mycelien
