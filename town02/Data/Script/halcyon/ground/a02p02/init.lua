--[[ a02p02 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local a02p02 = {}

function a02p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function a02p02.Enter(map)
  FugitiveArc.Play('a02p02')
end

function a02p02.Update(map) end
function a02p02.GameSave(map) end
function a02p02.GameLoad(map)
  GAME:FadeIn(20)
end

return a02p02
