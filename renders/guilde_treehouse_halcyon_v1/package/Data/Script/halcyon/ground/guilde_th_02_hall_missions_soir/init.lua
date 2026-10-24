-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_02_hall_missions_soir
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_02_hall_missions_soir = {}

function guilde_th_02_hall_missions_soir.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_02_hall_missions_soir.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_02_hall_missions_soir.Update(map) end
function guilde_th_02_hall_missions_soir.GameSave(map) end
function guilde_th_02_hall_missions_soir.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_02_hall_missions_soir.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_01_accueil_soir', 'Entree_Nord')
end

function guilde_th_02_hall_missions_soir.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_04_cantine_soir', 'Entree_Est')
end

function guilde_th_02_hall_missions_soir.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_03_salle_commune_soir', 'Entree_Echelle_Nord')
end

function guilde_th_02_hall_missions_soir.Porte_Maitre_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_12_salle_chef_soir', 'Entree_Sud')
end

return guilde_th_02_hall_missions_soir
