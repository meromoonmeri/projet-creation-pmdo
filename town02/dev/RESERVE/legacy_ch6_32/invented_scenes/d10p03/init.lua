-- [dungeon_builder] recâblage : conclusion de frosty_grotto sur son Ground final : la scène s'y termine, aucun renvoi vers une ancienne implémentation
-- [dungeon_builder] scène re-raccordée au donjon reconstruit : frosty_forest seg 2 -> frosty_grotto seg 0 étage 0. d10p03 est la scène de fin de la Forêt Givrée (Artikodin) : la suite canonique est la Grotte Givrée, désormais un donjon à part entière de 5 étages
--[[ d10p03 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d10p03 = {}

function d10p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d10p03.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending=='frosty_forest_summit' then
    local ok,scene=pcall(require,'halcyon.arc_fugitif.scene.d10p03')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending=nil; GAME:FadeOut(false,30)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
  else FugitiveArc.Play('d10p03') end
end

function d10p03.Update(map) end
function d10p03.GameSave(map) end
function d10p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d10p03
