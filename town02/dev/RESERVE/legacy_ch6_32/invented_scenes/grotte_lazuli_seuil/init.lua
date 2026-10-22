--[[ grotte_lazuli_seuil — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local grotte_lazuli_seuil = {}

function grotte_lazuli_seuil.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function grotte_lazuli_seuil.Enter(map)
  FugitiveArc.Play('grotte_lazuli_seuil')
end

function grotte_lazuli_seuil.Update(map) end
function grotte_lazuli_seuil.GameSave(map) end
function grotte_lazuli_seuil.GameLoad(map)
  GAME:FadeIn(20)
end

return grotte_lazuli_seuil
