-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_12_salle_chef
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_12_salle_chef = {}

function guilde_th_12_salle_chef.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_12_salle_chef.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef.Update(map) end
function guilde_th_12_salle_chef.GameSave(map) end
function guilde_th_12_salle_chef.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_12_salle_chef.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_02_hall_missions_' .. amb, 'Entree_Porte_Maitre')
  else
    GAME:EnterGroundMap('guilde_th_02_hall_missions', 'Entree_Porte_Maitre')
  end
end

return guilde_th_12_salle_chef
