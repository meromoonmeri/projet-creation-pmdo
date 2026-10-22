-- Waves of Nostalgia -> PMDO : overw1 (spring).
-- Sorties posees sur des bords franchissables mesures dans la collision.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) end
function M.Exit(map) end
function M.Update(map) end
-- canonique : overw1 est -> overw3
function M.Exit_est_overw3_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw3_spring', 'Entry_ouest')
end
-- canonique : overw1 sud -> overw2
function M.Exit_sud_overw2_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('won_overw2_spring', 'Entry_nord')
end
-- jonction d'adaptation : overw1 ouest -> nnv_rmvillage
function M.Exit_ouest_nnv_rmvillage_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rmvillage_spring', 'Entry_est')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
