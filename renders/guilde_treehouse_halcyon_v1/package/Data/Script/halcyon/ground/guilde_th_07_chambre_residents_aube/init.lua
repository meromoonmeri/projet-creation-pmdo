-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_07_chambre_residents_aube
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_07_chambre_residents_aube = {}

function guilde_th_07_chambre_residents_aube.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_07_chambre_residents_aube.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_07_chambre_residents_aube.Update(map) end
function guilde_th_07_chambre_residents_aube.GameSave(map) end
function guilde_th_07_chambre_residents_aube.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_07_chambre_residents_aube.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_aube', 'Entree_Est')
end

return guilde_th_07_chambre_residents_aube
