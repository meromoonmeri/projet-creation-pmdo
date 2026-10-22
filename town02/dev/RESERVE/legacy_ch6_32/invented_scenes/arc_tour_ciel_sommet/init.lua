--[[ arc_tour_ciel_sommet — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Copie 1:1 de tour_ciel_sommet (géométrie pixel-perfect), AssetName distinct du
     climax ch10. Scène jouée par FugitiveArc.Play. ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local arc_tour_ciel_sommet = {}

function arc_tour_ciel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function arc_tour_ciel_sommet.Enter(map)
  FugitiveArc.Play('arc_tour_ciel_sommet')
end

function arc_tour_ciel_sommet.Update(map) end
function arc_tour_ciel_sommet.GameSave(map) end
function arc_tour_ciel_sommet.GameLoad(map)
  GAME:FadeIn(20)
end

return arc_tour_ciel_sommet
