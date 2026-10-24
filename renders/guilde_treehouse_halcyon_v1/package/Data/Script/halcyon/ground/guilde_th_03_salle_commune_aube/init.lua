-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_03_salle_commune_aube
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_03_salle_commune_aube = {}

function guilde_th_03_salle_commune_aube.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_03_salle_commune_aube.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune_aube.Update(map) end
function guilde_th_03_salle_commune_aube.GameSave(map) end
function guilde_th_03_salle_commune_aube.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune_aube.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_aube', 'Entree_Echelle_Nord')
end

function guilde_th_03_salle_commune_aube.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_05_chambre_equipe_aube', 'Entree_Est')
end

function guilde_th_03_salle_commune_aube.Passage_Est_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_07_chambre_residents_aube', 'Entree_Ouest')
end

function guilde_th_03_salle_commune_aube.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_09_dortoir_quatre_aube', 'Entree_Nord')
end

return guilde_th_03_salle_commune_aube
