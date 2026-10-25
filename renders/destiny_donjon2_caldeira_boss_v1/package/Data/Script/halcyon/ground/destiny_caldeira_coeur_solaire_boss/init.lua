require 'origin.common'
local destiny_caldeira_coeur_solaire_boss = {}
function destiny_caldeira_coeur_solaire_boss.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function destiny_caldeira_coeur_solaire_boss.Enter(map) GAME:FadeIn(20) end
function destiny_caldeira_coeur_solaire_boss.Exit(map) end
function destiny_caldeira_coeur_solaire_boss.Update(map) end
function destiny_caldeira_coeur_solaire_boss.GameSave(map) end
function destiny_caldeira_coeur_solaire_boss.GameLoad(map) GAME:FadeIn(20) end
return destiny_caldeira_coeur_solaire_boss
