--[[ p05p03a — Ground cinématique piloté par le curseur FutureArc.
     Les transitions et retours de donjon appartiennent exclusivement au
     contrôleur persistant ; aucun AfterDungeon local n'est utilisé. ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local p05p03a = {}

function p05p03a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

local function resume()
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  FutureArc.Resume('p05p03a')
end

function p05p03a.Enter(map) resume() end
function p05p03a.Update(map) end
function p05p03a.GameSave(map) end
function p05p03a.GameLoad(map) resume() end

return p05p03a
