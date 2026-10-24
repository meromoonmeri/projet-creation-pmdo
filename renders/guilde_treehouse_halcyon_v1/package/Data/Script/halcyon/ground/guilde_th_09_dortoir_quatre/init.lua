-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_09_dortoir_quatre
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_09_dortoir_quatre = {}

function guilde_th_09_dortoir_quatre.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_09_dortoir_quatre.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_09_dortoir_quatre.Update(map) end
function guilde_th_09_dortoir_quatre.GameSave(map) end
function guilde_th_09_dortoir_quatre.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_09_dortoir_quatre.Passage_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_03_salle_commune_' .. amb, 'Entree_Sud')
  else
    GAME:EnterGroundMap('guilde_th_03_salle_commune', 'Entree_Sud')
  end
end

return guilde_th_09_dortoir_quatre
