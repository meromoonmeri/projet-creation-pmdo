-- Waves of Nostalgia -> PMDO : overw2 (summer).
-- Sorties posees sur des bords franchissables mesures dans la collision.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
-- canonique : overw2 nord -> overw1
function M.Exit_nord_overw1_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw1_summer', 'Entry_sud')
end
-- canonique : overw2 sud -> overw4
function M.Exit_sud_overw4_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw4_summer', 'Entry_nord')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
