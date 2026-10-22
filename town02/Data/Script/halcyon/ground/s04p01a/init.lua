require 'origin.common'
local s04p01a = {}
function s04p01a.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies(true) end
function s04p01a.Enter(map) GAME:FadeIn(20) end
function s04p01a.Update(map, time) end
function s04p01a.GameSave(map) end
function s04p01a.GameLoad(map) end
return s04p01a
