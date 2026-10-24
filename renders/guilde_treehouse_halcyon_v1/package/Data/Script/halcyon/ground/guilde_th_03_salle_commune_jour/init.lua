-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_03_salle_commune_jour
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_03_salle_commune_jour = {}

function guilde_th_03_salle_commune_jour.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_03_salle_commune_jour.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune_jour.Update(map) end
function guilde_th_03_salle_commune_jour.GameSave(map) end
function guilde_th_03_salle_commune_jour.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune_jour.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_jour', 'Entree_Echelle_Nord')
end

function guilde_th_03_salle_commune_jour.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_05_chambre_equipe_jour', 'Entree_Est')
end

function guilde_th_03_salle_commune_jour.Passage_Est_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_07_chambre_residents_jour', 'Entree_Ouest')
end

function guilde_th_03_salle_commune_jour.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_09_dortoir_quatre_jour', 'Entree_Nord')
end

return guilde_th_03_salle_commune_jour
