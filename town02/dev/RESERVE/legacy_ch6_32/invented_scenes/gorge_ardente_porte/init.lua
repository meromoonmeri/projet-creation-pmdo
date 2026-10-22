--[[ gorge_ardente_porte — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local gorge_ardente_porte = {}

function gorge_ardente_porte.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function gorge_ardente_porte.Enter(map)
  FugitiveArc.Play('gorge_ardente_porte')
end

function gorge_ardente_porte.Update(map) end
function gorge_ardente_porte.GameSave(map) end
function gorge_ardente_porte.GameLoad(map)
  GAME:FadeIn(20)
end

return gorge_ardente_porte
