require 'origin.common'
local ruines_enfouies_sanctuaire_mew = {}
function ruines_enfouies_sanctuaire_mew.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end
function ruines_enfouies_sanctuaire_mew.Enter(map) GAME:FadeIn(20) end
function ruines_enfouies_sanctuaire_mew.Exit(map) end
function ruines_enfouies_sanctuaire_mew.Update(map) end
function ruines_enfouies_sanctuaire_mew.GameSave(map) end
function ruines_enfouies_sanctuaire_mew.GameLoad(map) GAME:FadeIn(20) end
return ruines_enfouies_sanctuaire_mew
