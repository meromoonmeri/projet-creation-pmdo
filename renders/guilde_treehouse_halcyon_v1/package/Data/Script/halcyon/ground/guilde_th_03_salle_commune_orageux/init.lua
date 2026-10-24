-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_03_salle_commune_orageux
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_03_salle_commune_orageux = {}

function guilde_th_03_salle_commune_orageux.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_03_salle_commune_orageux.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune_orageux.Update(map) end
function guilde_th_03_salle_commune_orageux.GameSave(map) end
function guilde_th_03_salle_commune_orageux.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune_orageux.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_orageux', 'Entree_Echelle_Nord')
end

function guilde_th_03_salle_commune_orageux.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_05_chambre_equipe_orageux', 'Entree_Est')
end

function guilde_th_03_salle_commune_orageux.Passage_Est_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_07_chambre_residents_orageux', 'Entree_Ouest')
end

function guilde_th_03_salle_commune_orageux.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_09_dortoir_quatre_orageux', 'Entree_Nord')
end

return guilde_th_03_salle_commune_orageux
