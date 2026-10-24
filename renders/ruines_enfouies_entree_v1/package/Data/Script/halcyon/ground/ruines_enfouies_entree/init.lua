require 'origin.common'
local ruines_enfouies_entree = {}
function ruines_enfouies_entree.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function ruines_enfouies_entree.Enter(map) GAME:FadeIn(20) end
function ruines_enfouies_entree.Exit(map) end
function ruines_enfouies_entree.Update(map) end
function ruines_enfouies_entree.GameSave(map) end
function ruines_enfouies_entree.GameLoad(map) GAME:FadeIn(20) end
return ruines_enfouies_entree
