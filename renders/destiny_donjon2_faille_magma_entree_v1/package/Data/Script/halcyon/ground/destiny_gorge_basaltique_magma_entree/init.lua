require 'origin.common'
local destiny_gorge_basaltique_magma_entree = {}
function destiny_gorge_basaltique_magma_entree.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function destiny_gorge_basaltique_magma_entree.Enter(map) GAME:FadeIn(20) end
function destiny_gorge_basaltique_magma_entree.Exit(map) end
function destiny_gorge_basaltique_magma_entree.Update(map) end
function destiny_gorge_basaltique_magma_entree.GameSave(map) end
function destiny_gorge_basaltique_magma_entree.GameLoad(map) GAME:FadeIn(20) end
return destiny_gorge_basaltique_magma_entree
