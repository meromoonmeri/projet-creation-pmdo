--[[ d21p41a — Ground cinématique piloté par le curseur FutureArc.
     Les transitions et retours de donjon appartiennent exclusivement au
     contrôleur persistant ; aucun AfterDungeon local n'est utilisé. ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local d21p41a = {}

function d21p41a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

local function resume()
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  FutureArc.Resume('d21p41a')
end

function d21p41a.Enter(map) resume() end
function d21p41a.Update(map) end
function d21p41a.GameSave(map) end
function d21p41a.GameLoad(map) resume() end

return d21p41a
