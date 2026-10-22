--[[ d22p11a — Ground cinématique piloté par le curseur FutureArc.
     Les transitions et retours de donjon appartiennent exclusivement au
     contrôleur persistant ; aucun AfterDungeon local n'est utilisé. ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local d22p11a = {}

function d22p11a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

local function resume()
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  FutureArc.Resume('d22p11a')
end

function d22p11a.Enter(map) resume() end
function d22p11a.Update(map) end
function d22p11a.GameSave(map) end
function d22p11a.GameLoad(map) resume() end

return d22p11a
