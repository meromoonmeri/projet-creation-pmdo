-- [dungeon_builder] recâblage : scène canonique de transition : elle enchaîne sur mt_blaze_peak, donjon suivant de la chaîne PMD Red
--[[ d09p02 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d09p02 = {}

function d09p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d09p02.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending == 'mt_blaze_mid' then
    local ok, scene = pcall(require, 'halcyon.arc_fugitif.scene.d09p02')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending = nil
    GAME:FadeOut(false, 30)
    GAME:EnterDungeon('mt_blaze_peak', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  else
    FugitiveArc.Play('d09p02')
  end
end

function d09p02.Update(map) end
function d09p02.GameSave(map) end
function d09p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d09p02
