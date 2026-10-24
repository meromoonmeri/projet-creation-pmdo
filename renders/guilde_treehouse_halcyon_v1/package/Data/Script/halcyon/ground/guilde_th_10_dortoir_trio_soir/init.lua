-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_10_dortoir_trio_soir
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_10_dortoir_trio_soir = {}

function guilde_th_10_dortoir_trio_soir.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_10_dortoir_trio_soir.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_10_dortoir_trio_soir.Update(map) end
function guilde_th_10_dortoir_trio_soir.GameSave(map) end
function guilde_th_10_dortoir_trio_soir.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_10_dortoir_trio_soir.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_soir', 'Entree_Est')
end

return guilde_th_10_dortoir_trio_soir
