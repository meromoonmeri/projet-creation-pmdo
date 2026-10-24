-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_11_chambre_eclaireurs
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_11_chambre_eclaireurs = {}

function guilde_th_11_chambre_eclaireurs.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_11_chambre_eclaireurs.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_11_chambre_eclaireurs.Update(map) end
function guilde_th_11_chambre_eclaireurs.GameSave(map) end
function guilde_th_11_chambre_eclaireurs.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_11_chambre_eclaireurs.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_03_salle_commune_' .. amb, 'Entree_Est')
  else
    GAME:EnterGroundMap('guilde_th_03_salle_commune', 'Entree_Est')
  end
end

return guilde_th_11_chambre_eclaireurs
