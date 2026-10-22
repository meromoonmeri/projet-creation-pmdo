--[[ d21p21a — Ground cinématique piloté par le curseur FutureArc.
     Les transitions et retours de donjon appartiennent exclusivement au
     contrôleur persistant ; aucun AfterDungeon local n'est utilisé. ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local d21p21a = {}

function d21p21a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

local function resume()
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  FutureArc.Resume('d21p21a')
end

function d21p21a.Enter(map) resume() end
function d21p21a.Update(map) end
function d21p21a.GameSave(map) end
function d21p21a.GameLoad(map) resume() end

return d21p21a
