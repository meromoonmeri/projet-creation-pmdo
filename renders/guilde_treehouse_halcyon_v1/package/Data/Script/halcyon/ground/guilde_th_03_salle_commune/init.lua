-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_03_salle_commune
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_03_salle_commune = {}

function guilde_th_03_salle_commune.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_03_salle_commune.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune.Update(map) end
function guilde_th_03_salle_commune.GameSave(map) end
function guilde_th_03_salle_commune.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_03_salle_commune.Echelle_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_02_hall_missions_' .. amb, 'Entree_Echelle_Nord')
  else
    GAME:EnterGroundMap('guilde_th_02_hall_missions', 'Entree_Echelle_Nord')
  end
end

function guilde_th_03_salle_commune.Passage_Ouest_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_05_chambre_equipe_' .. amb, 'Entree_Est')
  else
    GAME:EnterGroundMap('guilde_th_05_chambre_equipe', 'Entree_Est')
  end
end

function guilde_th_03_salle_commune.Passage_Est_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_07_chambre_residents_' .. amb, 'Entree_Ouest')
  else
    GAME:EnterGroundMap('guilde_th_07_chambre_residents', 'Entree_Ouest')
  end
end

function guilde_th_03_salle_commune.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_09_dortoir_quatre_' .. amb, 'Entree_Nord')
  else
    GAME:EnterGroundMap('guilde_th_09_dortoir_quatre', 'Entree_Nord')
  end
end

return guilde_th_03_salle_commune
