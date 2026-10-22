--[[ p08p01a — Ground cinématique piloté par le curseur FutureArc.
     Les transitions et retours de donjon appartiennent exclusivement au
     contrôleur persistant ; aucun AfterDungeon local n'est utilisé. ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local p08p01a = {}

function p08p01a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

local function resume()
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  FutureArc.Resume('p08p01a')
end

function p08p01a.Enter(map) resume() end
function p08p01a.Update(map) end
function p08p01a.GameSave(map) end
function p08p01a.GameLoad(map) resume() end

return p08p01a
