--[[ arc_palier_celeste — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Copie 1:1 de palier_celeste (géométrie pixel-perfect), AssetName distinct du
     climax ch10. Scène jouée par FugitiveArc.Play. ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local arc_palier_celeste = {}

function arc_palier_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function arc_palier_celeste.Enter(map)
  FugitiveArc.Play('arc_palier_celeste')
end

function arc_palier_celeste.Update(map) end
function arc_palier_celeste.GameSave(map) end
function arc_palier_celeste.GameLoad(map)
  GAME:FadeIn(20)
end

return arc_palier_celeste
