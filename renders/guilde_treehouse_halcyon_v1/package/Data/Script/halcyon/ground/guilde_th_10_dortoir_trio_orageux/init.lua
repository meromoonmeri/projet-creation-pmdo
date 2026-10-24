-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_10_dortoir_trio_orageux
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_10_dortoir_trio_orageux = {}

function guilde_th_10_dortoir_trio_orageux.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_10_dortoir_trio_orageux.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_10_dortoir_trio_orageux.Update(map) end
function guilde_th_10_dortoir_trio_orageux.GameSave(map) end
function guilde_th_10_dortoir_trio_orageux.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_10_dortoir_trio_orageux.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_orageux', 'Entree_Est')
end

return guilde_th_10_dortoir_trio_orageux
