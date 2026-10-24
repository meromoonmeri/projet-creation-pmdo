-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_06_chambre_veilleur
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_06_chambre_veilleur = {}

function guilde_th_06_chambre_veilleur.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_06_chambre_veilleur.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_06_chambre_veilleur.Update(map) end
function guilde_th_06_chambre_veilleur.GameSave(map) end
function guilde_th_06_chambre_veilleur.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_06_chambre_veilleur.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_03_salle_commune_' .. amb, 'Centre')
  else
    GAME:EnterGroundMap('guilde_th_03_salle_commune', 'Centre')
  end
end

return guilde_th_06_chambre_veilleur
