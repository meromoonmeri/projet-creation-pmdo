-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_11_chambre_eclaireurs_nuit
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_11_chambre_eclaireurs_nuit = {}

function guilde_th_11_chambre_eclaireurs_nuit.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_11_chambre_eclaireurs_nuit.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_11_chambre_eclaireurs_nuit.Update(map) end
function guilde_th_11_chambre_eclaireurs_nuit.GameSave(map) end
function guilde_th_11_chambre_eclaireurs_nuit.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_11_chambre_eclaireurs_nuit.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_nuit', 'Entree_Est')
end

return guilde_th_11_chambre_eclaireurs_nuit
