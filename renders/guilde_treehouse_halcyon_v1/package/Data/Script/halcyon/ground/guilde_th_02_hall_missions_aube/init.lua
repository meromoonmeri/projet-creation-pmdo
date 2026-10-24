-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_02_hall_missions_aube
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_02_hall_missions_aube = {}

function guilde_th_02_hall_missions_aube.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_02_hall_missions_aube.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_02_hall_missions_aube.Update(map) end
function guilde_th_02_hall_missions_aube.GameSave(map) end
function guilde_th_02_hall_missions_aube.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_02_hall_missions_aube.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_01_accueil_aube', 'Entree_Nord')
end

function guilde_th_02_hall_missions_aube.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_04_cantine_aube', 'Entree_Est')
end

function guilde_th_02_hall_missions_aube.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_aube', 'Entree_Echelle_Nord')
end

function guilde_th_02_hall_missions_aube.Porte_Maitre_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_12_salle_chef_aube', 'Entree_Sud')
end

return guilde_th_02_hall_missions_aube
