--[[ grotte_lazuli_fond — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local grotte_lazuli_fond = {}

function grotte_lazuli_fond.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function grotte_lazuli_fond.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending=='lapis_cave_exit' then
    local ok,scene=pcall(require,'halcyon.arc_fugitif.scene.d08p02')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending=nil;SV.CanonicalDungeons.LapisCaveCleared=true
    GAME:FadeOut(false,30);GAME:EnterZone('master_zone',-1,1,0)
  else FugitiveArc.Play('grotte_lazuli_fond') end
end

function grotte_lazuli_fond.Update(map) end
function grotte_lazuli_fond.GameSave(map) end
function grotte_lazuli_fond.GameLoad(map)
  GAME:FadeIn(20)
end

return grotte_lazuli_fond
