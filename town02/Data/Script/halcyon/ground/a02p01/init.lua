--[[ a02p01 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local a02p01 = {}

function a02p01.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function a02p01.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FugitiveArc.Play('a02p01')
end

function a02p01.Update(map) end
function a02p01.GameSave(map) end
function a02p01.GameLoad(map)
  GAME:FadeIn(20)
end

return a02p01
