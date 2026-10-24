-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour guilde_th_01_accueil_nuit
-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).
require 'origin.common'

local guilde_th_01_accueil_nuit = {}

function guilde_th_01_accueil_nuit.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end

function guilde_th_01_accueil_nuit.Enter(map)
  GAME:FadeIn(20)
end

function guilde_th_01_accueil_nuit.Update(map) end
function guilde_th_01_accueil_nuit.GameSave(map) end
function guilde_th_01_accueil_nuit.GameLoad(map)
  GAME:FadeIn(20)
end

function guilde_th_01_accueil_nuit.Passage_Nord_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('guilde_th_02_hall_missions_nuit', 'Entree_Sud')
end

function guilde_th_01_accueil_nuit.Passage_Sud_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('metano_town', 'Entrance')
end

return guilde_th_01_accueil_nuit
