-- Waves of Nostalgia -> PMDO : overw4 (winter).
-- Sorties posees sur des bords franchissables mesures dans la collision.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
-- canonique : overw4 nord -> overw2
function M.Exit_nord_overw2_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw2_winter', 'Entry_sud')
end
-- canonique : overw4 est -> overw4a
function M.Exit_est_overw4a_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw4a_winter', 'Entry_ouest')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
