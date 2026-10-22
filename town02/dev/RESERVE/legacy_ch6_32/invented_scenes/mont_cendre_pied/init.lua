--[[ mont_cendre_pied — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local mont_cendre_pied = {}

function mont_cendre_pied.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function mont_cendre_pied.Enter(map)
  FugitiveArc.Play('mont_cendre_pied')
end

function mont_cendre_pied.Update(map) end
function mont_cendre_pied.GameSave(map) end
function mont_cendre_pied.GameLoad(map)
  GAME:FadeIn(20)
end

return mont_cendre_pied
