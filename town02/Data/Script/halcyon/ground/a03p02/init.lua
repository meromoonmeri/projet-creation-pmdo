--[[ a03p02 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT (géométrie, collision
     et positions d'entités 1:1). La scène est jouée par
     FugitiveArc.Play (dialogues par clés SCENE_*). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local a03p02 = {}

function a03p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function a03p02.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FugitiveArc.Play('a03p02')
end

function a03p02.Update(map) end
function a03p02.GameSave(map) end
function a03p02.GameLoad(map)
  GAME:FadeIn(20)
end

return a03p02
