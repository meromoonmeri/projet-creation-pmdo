--[[ a04p01 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local a04p01 = {}

function a04p01.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function a04p01.Enter(map)
  FugitiveArc.Play('a04p01')
end

function a04p01.Update(map) end
function a04p01.GameSave(map) end
function a04p01.GameLoad(map)
  GAME:FadeIn(20)
end

return a04p01
