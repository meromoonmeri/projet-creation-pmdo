-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_06_chambre_veilleur_aube
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_06_chambre_veilleur_aube = {}

function guilde_th_06_chambre_veilleur_aube.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_06_chambre_veilleur_aube.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_06_chambre_veilleur_aube.Update(map) end
function guilde_th_06_chambre_veilleur_aube.GameSave(map) end
function guilde_th_06_chambre_veilleur_aube.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_06_chambre_veilleur_aube.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_aube', 'Centre')
end

return guilde_th_06_chambre_veilleur_aube
