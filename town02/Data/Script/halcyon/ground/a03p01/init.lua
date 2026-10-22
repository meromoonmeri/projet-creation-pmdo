--[[ a03p01 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT (géométrie, collision
     et positions d'entités 1:1). La scène est jouée par
     FugitiveArc.Play (dialogues par clés SCENE_*). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local a03p01 = {}

function a03p01.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function a03p01.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FugitiveArc.Play('a03p01')
end

function a03p01.Update(map) end
function a03p01.GameSave(map) end
function a03p01.GameLoad(map)
  GAME:FadeIn(20)
end

return a03p01
