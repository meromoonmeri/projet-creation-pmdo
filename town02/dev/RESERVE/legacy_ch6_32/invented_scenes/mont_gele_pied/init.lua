--[[ mont_gele_pied — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local mont_gele_pied = {}

function mont_gele_pied.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function mont_gele_pied.Enter(map)
  FugitiveArc.Play('mont_gele_pied')
end

function mont_gele_pied.Update(map) end
function mont_gele_pied.GameSave(map) end
function mont_gele_pied.GameLoad(map)
  GAME:FadeIn(20)
end

return mont_gele_pied
