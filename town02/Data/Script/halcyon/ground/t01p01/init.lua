--[[ t01p01 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local t01p01 = {}

function t01p01.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function t01p01.Enter(map)
  FugitiveArc.Play('t01p01')
end

function t01p01.Update(map) end
function t01p01.GameSave(map) end
function t01p01.GameLoad(map)
  GAME:FadeIn(20)
end

return t01p01
