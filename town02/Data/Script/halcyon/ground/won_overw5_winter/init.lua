-- Waves of Nostalgia -> PMDO : overw5 (winter).
-- Sorties posees sur des bords franchissables mesures dans la collision.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
-- canonique : overw5 ouest -> overw3
function M.Exit_ouest_overw3_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw3_winter', 'Entry_est')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
