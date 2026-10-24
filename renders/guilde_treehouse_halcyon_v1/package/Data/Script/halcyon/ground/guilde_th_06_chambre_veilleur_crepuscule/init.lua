-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_06_chambre_veilleur_crepuscule
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_06_chambre_veilleur_crepuscule = {}

function guilde_th_06_chambre_veilleur_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_06_chambre_veilleur_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_06_chambre_veilleur_crepuscule.Update(map) end
function guilde_th_06_chambre_veilleur_crepuscule.GameSave(map) end
function guilde_th_06_chambre_veilleur_crepuscule.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_06_chambre_veilleur_crepuscule.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_crepuscule', 'Centre')
end

return guilde_th_06_chambre_veilleur_crepuscule
