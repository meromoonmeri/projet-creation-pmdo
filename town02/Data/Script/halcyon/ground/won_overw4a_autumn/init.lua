-- Waves of Nostalgia -> PMDO : overw4a (autumn).
-- Sorties posees sur des bords franchissables mesures dans la collision.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
-- canonique : overw4a ouest -> overw4
function M.Exit_ouest_overw4_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw4_autumn', 'Entry_est')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
