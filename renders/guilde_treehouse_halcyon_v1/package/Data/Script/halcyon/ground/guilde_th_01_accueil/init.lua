-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_01_accueil
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_01_accueil = {}

function guilde_th_01_accueil.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_01_accueil.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_01_accueil.Update(map) end
function guilde_th_01_accueil.GameSave(map) end
function guilde_th_01_accueil.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_01_accueil.Passage_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_02_hall_missions_' .. amb, 'Entree_Sud')
  else
    GAME:EnterGroundMap('guilde_th_02_hall_missions', 'Entree_Sud')
  end
end

function guilde_th_01_accueil.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('metano_town', 'Entrance')
end

return guilde_th_01_accueil
