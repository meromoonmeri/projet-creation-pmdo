-- Waves of Nostalgia -> PMDO : overw3 (spring).
-- Sorties posees sur des bords franchissables mesures dans la collision.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
-- canonique : overw3 ouest -> overw1
function M.Exit_ouest_overw1_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw1_spring', 'Entry_est')
end
-- canonique : overw3 est -> overw5
function M.Exit_est_overw5_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw5_spring', 'Entry_ouest')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
