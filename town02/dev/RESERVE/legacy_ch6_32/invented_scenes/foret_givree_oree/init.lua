--[[ foret_givree_oree — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local foret_givree_oree = {}

function foret_givree_oree.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function foret_givree_oree.Enter(map)
  FugitiveArc.Play('foret_givree_oree')
end

function foret_givree_oree.Update(map) end
function foret_givree_oree.GameSave(map) end
function foret_givree_oree.GameLoad(map)
  GAME:FadeIn(20)
end

return foret_givree_oree
