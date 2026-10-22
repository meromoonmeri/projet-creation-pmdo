--[[ d11p03 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d11p03 = {}

function d11p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d11p03.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending=='mt_freeze_summit' then
    local ok,scene=pcall(require,'halcyon.arc_fugitif.scene.d11p03')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending=nil
    SV.CanonicalDungeons.MtFreezeCleared=true
    GAME:FadeOut(false,30)
    GAME:EnterZone('master_zone',-1,1,0)
  else FugitiveArc.Play('d11p03') end
end

function d11p03.Update(map) end
function d11p03.GameSave(map) end
function d11p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d11p03
