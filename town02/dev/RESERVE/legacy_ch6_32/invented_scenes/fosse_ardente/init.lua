-- [dungeon_builder] recâblage : conclusion de magma_cavern_pit sur son Ground final : la scène s'y termine, aucun renvoi vers une ancienne implémentation
--[[ fosse_ardente — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local fosse_ardente = {}

function fosse_ardente.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function fosse_ardente.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending=='magma_cavern_pit' then
    local ok,scene=pcall(require,'halcyon.arc_fugitif.scene.d12p04')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    -- Le réveil et ses VFX sont entièrement joués par d12p04.Cutscene.
    -- Ne pas superposer un second effet à une autre coordonnée.
    SV.CanonicalDungeons.Pending=nil;GAME:FadeOut(false,30)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
  else FugitiveArc.Play('fosse_ardente') end
end

function fosse_ardente.Update(map) end
function fosse_ardente.GameSave(map) end
function fosse_ardente.GameLoad(map)
  GAME:FadeIn(20)
end

return fosse_ardente
