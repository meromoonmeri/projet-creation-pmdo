-- [dungeon_builder] script de Ground canonique généré — ne pas éditer à la main.
--[[ d06p02 — relais canonique de mt_thunder.
     Ground canonique existant : la scène, le combat et la conclusion s'y
     déroulent au même endroit. Ce script assure uniquement la continuité du
     parcours ; les dialogues restent portés par la scène du Ground.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local d06p02 = {}

function d06p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d06p02.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('mt_thunder_peak', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function d06p02.Update(map) end
function d06p02.GameSave(map) end
function d06p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d06p02
