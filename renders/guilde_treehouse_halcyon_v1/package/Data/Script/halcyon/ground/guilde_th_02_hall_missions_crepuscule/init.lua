-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_02_hall_missions_crepuscule
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_02_hall_missions_crepuscule = {}

function guilde_th_02_hall_missions_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_02_hall_missions_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_02_hall_missions_crepuscule.Update(map) end
function guilde_th_02_hall_missions_crepuscule.GameSave(map) end
function guilde_th_02_hall_missions_crepuscule.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_02_hall_missions_crepuscule.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_01_accueil_crepuscule', 'Entree_Nord')
end

function guilde_th_02_hall_missions_crepuscule.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_04_cantine_crepuscule', 'Entree_Est')
end

function guilde_th_02_hall_missions_crepuscule.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_crepuscule', 'Entree_Echelle_Nord')
end

function guilde_th_02_hall_missions_crepuscule.Porte_Maitre_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_12_salle_chef_crepuscule', 'Entree_Sud')
end

return guilde_th_02_hall_missions_crepuscule
