-- [dungeon_builder] script de Ground canonique généré — ne pas éditer à la main.
--[[ d07p02 — Ground final canonique de great_canyon.
     Ground canonique existant : la scène, le combat et la conclusion s'y
     déroulent au même endroit. Ce script assure uniquement la continuité du
     parcours ; les dialogues restent portés par la scène du Ground.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local d07p02 = {}

function d07p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d07p02.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['great_canyon'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d07p02.Update(map) end
function d07p02.GameSave(map) end
function d07p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d07p02
