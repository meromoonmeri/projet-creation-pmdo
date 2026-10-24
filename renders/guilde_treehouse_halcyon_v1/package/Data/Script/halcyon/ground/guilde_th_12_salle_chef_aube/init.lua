-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_12_salle_chef_aube
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_12_salle_chef_aube = {}

function guilde_th_12_salle_chef_aube.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_12_salle_chef_aube.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef_aube.Update(map) end
function guilde_th_12_salle_chef_aube.GameSave(map) end
function guilde_th_12_salle_chef_aube.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef_aube.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_aube', 'Entree_Porte_Maitre')
end

return guilde_th_12_salle_chef_aube
