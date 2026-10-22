-- [dungeon_builder] recâblage : scène canonique de transition : elle enchaîne sur magma_cavern_pit, donjon suivant de la chaîne PMD Red
--[[ gorge_ardente_coeur — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local gorge_ardente_coeur = {}

function gorge_ardente_coeur.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function gorge_ardente_coeur.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending=='magma_cavern_mid' then
    local ok,scene=pcall(require,'halcyon.arc_fugitif.scene.d12p02')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending=nil;GAME:FadeOut(false,30)
    GAME:EnterDungeon('magma_cavern_pit', 0, 0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
  else FugitiveArc.Play('gorge_ardente_coeur') end
end

function gorge_ardente_coeur.Update(map) end
function gorge_ardente_coeur.GameSave(map) end
function gorge_ardente_coeur.GameLoad(map)
  GAME:FadeIn(20)
end

return gorge_ardente_coeur
