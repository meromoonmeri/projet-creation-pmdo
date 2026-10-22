-- [dungeon_builder] recâblage : scène canonique de transition : elle enchaîne sur frosty_grotto, donjon suivant de la chaîne PMD Red
-- [dungeon_builder] scène re-raccordée au donjon reconstruit : frosty_forest seg 1 -> frosty_forest seg 0 étage 4. d10p02 est le relais de mi-parcours : la Forêt Givrée reconstruite tient en un seul segment de 9 étages, le relais renvoie donc au même segment à l'étage 5
--[[ d10p02 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d10p02 = {}

function d10p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d10p02.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending=='frosty_forest_mid' then
    local ok,scene=pcall(require,'halcyon.arc_fugitif.scene.d10p02')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending=nil; GAME:FadeOut(false,30)
    GAME:EnterDungeon('frosty_grotto', 0, 0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
  else FugitiveArc.Play('d10p02') end
end

function d10p02.Update(map) end
function d10p02.GameSave(map) end
function d10p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d10p02
