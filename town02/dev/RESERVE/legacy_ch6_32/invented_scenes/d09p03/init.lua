-- [dungeon_builder] recâblage : conclusion de mt_blaze_peak sur son Ground final : la scène s'y termine, aucun renvoi vers une ancienne implémentation
-- [dungeon_builder] scène re-raccordée au donjon reconstruit : mt_blaze seg 2 -> mt_blaze_peak seg 0 étage 0. d09p03 est la scène du sommet (Sulfura) : la suite canonique est la Cime du Mont Cendré, désormais un donjon à part entière de 3 étages
--[[ d09p03 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d09p03 = {}

function d09p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d09p03.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending == 'mt_blaze_summit' then
    local ok, scene = pcall(require, 'halcyon.arc_fugitif.scene.d09p03')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending = nil
    GAME:FadeOut(false, 30)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
  else
    FugitiveArc.Play('d09p03')
  end
end

function d09p03.Update(map) end
function d09p03.GameSave(map) end
function d09p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d09p03
