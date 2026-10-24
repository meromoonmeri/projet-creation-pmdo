-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_12_salle_chef_orageux
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_12_salle_chef_orageux = {}

function guilde_th_12_salle_chef_orageux.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_12_salle_chef_orageux.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef_orageux.Update(map) end
function guilde_th_12_salle_chef_orageux.GameSave(map) end
function guilde_th_12_salle_chef_orageux.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef_orageux.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_orageux', 'Entree_Porte_Maitre')
end

return guilde_th_12_salle_chef_orageux
