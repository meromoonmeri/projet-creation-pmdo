-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_04_cantine
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_04_cantine = {}

function guilde_th_04_cantine.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_04_cantine.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_04_cantine.Update(map) end
function guilde_th_04_cantine.GameSave(map) end
function guilde_th_04_cantine.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_04_cantine.Passage_Est_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  local amb = SV.guilde_treehouse_ambiance
  if amb and amb ~= '' then
    GAME:EnterGroundMap('guilde_th_02_hall_missions_' .. amb, 'Entree_Ouest')
  else
    GAME:EnterGroundMap('guilde_th_02_hall_missions', 'Entree_Ouest')
  end
end

return guilde_th_04_cantine
