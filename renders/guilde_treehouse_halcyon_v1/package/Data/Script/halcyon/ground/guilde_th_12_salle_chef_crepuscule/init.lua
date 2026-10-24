-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_12_salle_chef_crepuscule
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_12_salle_chef_crepuscule = {}

function guilde_th_12_salle_chef_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_12_salle_chef_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef_crepuscule.Update(map) end
function guilde_th_12_salle_chef_crepuscule.GameSave(map) end
function guilde_th_12_salle_chef_crepuscule.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef_crepuscule.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_crepuscule', 'Entree_Porte_Maitre')
end

return guilde_th_12_salle_chef_crepuscule
